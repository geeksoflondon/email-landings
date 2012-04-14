require 'rubygems'
require 'sinatra'
require 'createsend'


get '/' do
  erb :index
end

get '/update/:email' do
 #Show subscription settings for the email address
end

post '/update/:email' do
 #Update Campaign Monitor
end

get '/update/thankyou' do
 #Thankyou for updating
end