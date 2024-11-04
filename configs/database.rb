require 'sequel'

DB = Sequel.sqlite('db/inlima.db',timeout: 1000000)
Sequel::Model.plugin :json_serializer