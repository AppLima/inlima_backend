
require 'sinatra'
require_relative '../controllers/district'

district_controller = DistrictController.new

get '/district' do
  content_type :json
  district_controller.getDistricts
end
