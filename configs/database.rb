require 'sequel'

'''DB = Sequel.sqlite('db/app.db')'''
DB = Sequel.sqlite('db/inlima.db')
Sequel::Model.plugin :json_serializer