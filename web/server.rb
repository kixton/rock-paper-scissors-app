require 'sinatra'
require 'pry-byebug'
require_relative '../config/environments.rb'

class RPS::Server < Sinatra::Application 

  configure do
    set :bind, '0.0.0.0'
    enable :sessions
  end

  # homepage with info, leaderboard, quickplay
  get '/' do
    @players = RPS::Player.all
    @tourneys = RPS::Tourney.all
    @games = RPS::Game.all

    erb :index
  end

  # form to create new tourney
  get '/rps/new' do
    erb :newtourney
  end

  post '/rps' do
    @players = params[:players]

    # create new player entities
    tourney_players = []
    @players.each do |player|
      if RPS::Player.find_by(name: player[:name]) == nil
        tourney_players << RPS::Player.create(name: player[:name], phone: player[:phone], email: player[:email], wins: 0, losses: 0)
      else
        tourney_players << RPS::Player.find_by(name: player[:name])
      end
    end  

    binding.pry
    # create a new tourney
    tourney = RPS::Tourney.create(name: params[:tourney_name])

    x = tourney_players.length/2 # no of games to be created
    i = 0 # players counter
    until x == 0
      game = RPS::Game.create(tourney_id: tourney.id, round: 1)
      x -= 1
      RPS::Move.create(game_id: game.id, player_id: tourney_players[i].id)
      i += 1
      RPS::Move.create(game_id: game.id, player_id: tourney_players[i].id)
      i += 1
    end

    redirect to("/rps/" + tourney.id.to_s)
  end

  # get login form
  get '/login' do
    erb :login
  end

  post '/signup' do
    if RPS::Player.find_by(email: params[:email]) == nil
      RPS::Player.create(name: params[:name], email: params[:email], password: params[:password])
    end
    redirect to("/")
  end  

  # :id = tourney_id
  get '/rps/:id' do
    @games = RPS::Game.where(tourney_id: params[:id]) # array of games
    @tourney = RPS::Tourney.find(params[:id])
    # if session[:message]
    #   @message = session[:message] 
    #   session[:message] = nil
    # end

    erb :singletourney
  end

  # :id = move_id
  get '/play/:id' do
    @move = RPS::Move.where(id: params[:id])
    erb :play

  end  

  # :id == move_id
  post '/move/:id' do
    # find the move by move_id and update the move (RPS)
    move = RPS::Move.find(params[:id])
    move.update(move: params[:move])
    move.save

    tourney = move.game.tourney
    
    # call .opponent(player) on the game to determine the opponent
    opponent = move.game.opponent(move.player)

    opponent_move = RPS::Move.find_by(game_id: move.game_id, player_id: opponent.id)

    if opponent_move.move != nil 
      game = move.game
      result = game.play(move, opponent_move)

      if result == -1
        # clear game moves and start over again
        game.clear_moves
        game.tie = true
        game.save
        # session[:message] = "It was a tie"
      else
        game.winner_id = result
        game.tie = nil
        game.save
      end
    end

    # if all games have a winner, start next round
    w = RPS::Game.where(tourney_id: tourney, winner_id: nil)
    x = RPS::Game.where(tourney_id: tourney)
    rd1 = RPS::Game.where(tourney_id: tourney, round: 1)
    rd2 = RPS::Game.where(tourney_id: tourney, round: 2)
    rd3 = RPS::Game.where(tourney_id: tourney, round: 3)

    if w.length == 0 && x.length == 4
      RPS::Player.increment_count(:wins, rd1[0].winner)
      RPS::Player.increment_count(:wins, rd1[1].winner)
      RPS::Player.increment_count(:wins, rd1[2].winner)
      RPS::Player.increment_count(:wins, rd1[3].winner)

      rd2game1 = RPS::Game.create(tourney: tourney, round: 2)
      RPS::Move.create(game: rd2game1, player: rd1[0].winner)
      RPS::Move.create(game: rd2game1, player: rd1[1].winner)

      rd2game2 = RPS::Game.create(tourney: tourney, round: 2)
      RPS::Move.create(game: rd2game2, player: rd1[2].winner)
      RPS::Move.create(game: rd2game2, player: rd1[3].winner)
      binding.pry
    elsif w.length == 0 && x.length == 6
      RPS::Player.increment_count(:wins, rd2[0].winner)
      RPS::Player.increment_count(:wins, rd2[1].winner)

      rd3game1 = RPS::Game.create(tourney: tourney, round: 3)
      RPS::Move.create(game: rd3game1, player: rd2[0].winner)
      RPS::Move.create(game: rd3game1, player: rd2[1].winner)
    elsif w.length == 0 && x.length == 7
      RPS::Player.increment_count(:wins, rd3[0].winner)
      tourney.winner = rd3[0].winner
      tourney.save
    end

    redirect to("/rps/" + tourney.id.to_s)
  end  

end