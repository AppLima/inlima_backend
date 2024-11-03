
require 'sinatra'
require_relative '../controllers/subject'

subject_controller = SubjectController.new

get '/subject' do
  content_type :json
  subject_controller.getSubjects
end
