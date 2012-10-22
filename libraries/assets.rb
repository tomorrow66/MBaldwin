# Requests for images, script, and stylesheets are intercepted and processed here.
# This pulls assets out of ./public and moves them to the top directory level.
# To override processing, put your assets in ./public and call them normally.
#
# .scss, .sass, and .coffee assets should be requested with their actual extensions:
#	<link href="/stylesheets/theme.scss" rel="stylesheet" />
#	<script src="/scripts/interactions.coffee" type="text/javascript"></script>


get '/images/*/?' do
	if File.exists? "./images/#{params[:splat].first}"
		send_file "./images/#{params[:splat].first}"
	else
		error 404
	end
end

get '/scripts/*/?' do
  if File.exists? "./scripts/#{params[:splat].first}"
    if params[:splat].first.include? '.coffee'
      coffee :"#{params[:splat].first.gsub('.coffee', '')}", views: './scripts'
    else
      send_file "./scripts/#{params[:splat].first}"
    end
  else
    error 404
  end
end

get '/stylesheets/*/?' do
  if File.exists? "./stylesheets/#{params[:splat].first}"
    if params[:splat].first.include? '.scss'
      scss :"#{params[:splat].first.gsub('.scss', '')}", views: './stylesheets', style: :expanded
    elsif params[:splat].first.include? '.sass'
      sass :"#{params[:splat].first.gsub('.sass', '')}", views: './stylesheets', style: :expanded
    else
      send_file "./stylesheets/#{params[:splat].first}"
    end
  else
    error 404
  end
end