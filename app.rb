require 'rubygems'
require 'sinatra'
require 'createsend'

API_KEY = ENV['CM_KEY']
LIST_ID = '471955e41d63929cf0205d40334aac59'

get '/' do
  erb :index
end

post '/findme' do
  #see if we have the user on record and if we do fwd them to update email
end

#Show subscription settings for the email address
get '/update/:email' do
 @subscription = get_subscriber(params[:email])

 if @subscription.nil?
   redirect to('/')
 end

 erb :update

end

post '/update/:email' do
 puts params.inspect
end

get '/thankyou' do
 erb :thankyou
 #Thankyou for updating
end

def get_subscriber(email = '')

  begin

    CreateSend.api_key API_KEY
    @subscriber = CreateSend::Subscriber.get LIST_ID, email

  rescue Exception=>e
    return nil
  end

  user = {
    'email' => @subscriber.EmailAddress,
    'name' => @subscriber.Name,
    'first_name' => safe_field(@subscriber.CustomFields[0]),
    'last_name' => safe_field(@subscriber.CustomFields[1]),
    'everything' => safe_field(@subscriber.CustomFields[4]),
    'geek' => safe_field(@subscriber.CustomFields[5]),
    'hack' => safe_field(@subscriber.CustomFields[6]),
    'barcamp' => safe_field(@subscriber.CustomFields[7]),
    'events' => safe_field(@subscriber.CustomFields[8])
  }

  return user

end

def safe_field(field = '')
  unless field.nil?
    if field['Value'] == 'TRUE'
      return 'checked'
    else
      return ''
    end
  else
    return ''
  end
end