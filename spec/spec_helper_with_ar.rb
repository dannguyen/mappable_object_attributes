require 'spec_helper'

require 'active_record'
require 'database_cleaner'
require 'sqlite3'


RSpec.configure do |config|
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end




ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => ":memory:"
)
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :records do |t|
 
    t.timestamps
  end

end


DatabaseCleaner.clean_with(:truncation)