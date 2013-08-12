require 'spec_helper'

require 'active_record'
require 'protected_attributes'
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
  create_table :alice_maps do |t|
    t.string :name
    t.string :hed 
    t.integer :birth_year
    t.timestamps
  end

end


DatabaseCleaner.clean_with(:truncation)