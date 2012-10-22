['/sign-in/?', '/admin/?', '/signin/?'].each do |path|
  get path do
    erb :sign_in, layout: :admin
  end
end

post '/sign-in/?' do
  params[:email].strip!
  params[:email].downcase!
  params[:password].strip!
  params[:password].downcase!
  
  errors = 0
  flash[:alert] = ''
  
  if params[:email].length < 1
    flash[:alert] += ' You must enter an email.'
    errors += 1
  end

  if params[:password].length < 1
    flash[:alert] += ' You must enter a password.'
    errors += 1
  end
  
  if errors < 1  
    if user = User.first(email: params[:email], password: params[:password])
      session[:user] = user.id
    else
      flash[:alert] += ' Email or password incorrect.'
      errors += 1
    end
  end
  
  flash[:alert].strip!
  
  if errors > 0
    redirect '/sign-in'
  else
    flash[:alert] = "Welcome"
    user = User.first(email: params[:email])
    session[:user] = user.id
    redirect '/dashboard'
  end
  
end

get '/sign-out/?' do
  authenticate
  session[:user] = nil
  flash[:alert] = 'You are now signed out.'
  redirect '/sign-in'
end