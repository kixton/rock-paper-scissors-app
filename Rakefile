# require this gem to have access to prewritten rake tasks
require 'active_record_tasks'

ActiveRecordTasks.configure do |config|
  # default values
  config.db_dir = 'db'
  config.db_config_path = 'db/config.yml'
  # test environment
  config.env = 'test'
end

# Run this AFTER you've configured
# generate rake tasks
ActiveRecordTasks.load_tasks