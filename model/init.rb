module KamiParty
  # Here goes your database connection and options:
  DB = Sequel.sqlite #('cms.sqlite')

  Sequel::Model.plugin :schema
  Sequel::Model.plugin :validation_class_methods

  # Here go your requires for models:
  require 'model/user'
  require 'model/part'
end
