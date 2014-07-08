require 'sequel'

DB = Sequel.sqlite

DB.create_table :promotions do 
  String :code
end

DB.create_table :zones do
  String :name
  TrueClass :default_tax
end