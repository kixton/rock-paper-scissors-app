$(document).ready(function() {

  $("#subFormBtn").click(function(event){
    console.log("signup button pressed");

    var name = $("input[name=new_user_name]").val();
    var email = $("input[name=new_user_email]").val();
    var phone = $("input[name=new_user_phone]").val();
    var password = $("input[name=new_user_password]").val();

    $.post( "/signup", { name: name, email: email, phone: phone, password: password } );
  });

  $(".btn-lg").click(function(event) {
    console.log("move made");
    var id = $("input[name=game_id]").val();
    var move = $(this).val();

    console.log("move: " + move);
    console.log("move_id: " + id);

    $.post( "/move/" + id, { id: id, move: move }, function() {
      // window.location = "/rps/" + tourney_id
    } );

  });

  $("button").click(function(event) {
    // look at `event` or `this` 
    console.log("move clicked");
    var tourney_id = $(".tourney_id").attr("id");
    var id = $("[data-move-id]").attr("data-move-id");
    var move = $(this).val();

    console.log("move: " + move);
    console.log("move_id: " + id);
    console.log("tourney_id: " + tourney_id);

    $.post( "/move/" + id, { id: id, move: move }, function() {
      window.location = "/rps/" + tourney_id
    } );
  });


})  
