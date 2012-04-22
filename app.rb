require 'rubygems'
require 'sinatra'
require 'createsend'

##Some Config

API_KEY = ENV['CM_KEY']
LIST_ID = '471955e41d63929cf0205d40334aac59'

##HTTP Methods

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
 email = params[:email]
 barcamp = params[:barcamp]
 hack = params[:hack]
 anything = params[:anything]

 custom_fields = [{:Key => 'barcamp', :Value => clean_choice(barcamp)}, {:Key => 'hack', :Value => clean_choice(hack)}, {:Key => 'anything', :Value => clean_choice(anything)}]
 puts custom_fields.inspect
 subscription = get_subscriber(email)
 update = update_subscriber(subscription['email'], subscription['name'], custom_fields)

 redirect '/thankyou'
end

get '/thankyou' do
 erb :thankyou
end

get '/unsubscribe/:email' do
 unsubscribe_subscriber(params[:email])
 erb :unsubscribe
end

##CM Methods

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
    'anything' => safe_field(@subscriber.CustomFields[4]),
    'hack' => safe_field(@subscriber.CustomFields[5]),
    'barcamp' => safe_field(@subscriber.CustomFields[6])
  }

  return user

end

def update_subscriber(email = '', name  = '',  custom_fields = '')

  begin
    CreateSend.api_key API_KEY
    @subscriber = CreateSend::Subscriber.new LIST_ID, email
    email_address = @subscriber.update email, name, custom_fields, true
  rescue Exception=>e
    return e
  end

  return email_address

end

def unsubscribe_subscriber(email = '')

  begin
    CreateSend.api_key API_KEY
    @subscriber = CreateSend::Subscriber.new LIST_ID, email
    unsubscribe = @subscriber.unsubscribe()
  rescue Exception=>e
    return e
  end

  return email

end

##Helpers

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

def clean_choice(value = '')
  if value == nil
    return 'FALSE'
  else
    return 'TRUE'
  end
end