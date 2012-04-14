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
 erb :update
end

post '/update/:email' do
 #Update Campaign Monitor
end

get '/thankyou' do
 erb :thankyou
 #Thankyou for updating
end