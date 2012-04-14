require 'rubygems'
require 'sinatra'
require 'createsend'


get '/' do
  erb :index
end

post '/findme' do
  #see if we have the user on record and if we do fwd them to update email
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