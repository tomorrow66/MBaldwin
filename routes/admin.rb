helpers do 

  def authenticate 
    redirect 'sign-in' unless session[:user]
  end
  
  def embed_video(number)
    "<span class='videoWrapper'><iframe src='http://player.vimeo.com/video/#{number}?title=0&amp;byline=0&amp;portrait=0' class='video' width='500' height='281' frameborder='0' webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe></span>"
  end
  
  def right_size(path, img, width = 1000, height = 1000)
  	# Configurable Image max dimensions    
  	dimensions = FastImage.size(path + img)
  	
  	if width != 1000 || height != 1000
  		if ((width - 2)..(width + 2)) === dimensions[0] && ((height - 2)..(height + 2)) === dimensions[1]
  			arr = [true]
  			dimensions[0] > dimensions[1] ? arr << 'landscape' : arr << 'portrait' 
  		else
  			Dir.chdir(path)
	      File.delete(img)
	      Dir.chdir("../../../")
	  		arr = [false, width, height]
  		end
  	else
	  	if dimensions[0] >= (width + 1) || dimensions[1] >= (height + 1)
	  		Dir.chdir(path)
	      File.delete(img)
	      Dir.chdir("../../../")
	  		arr = [false, width, height]
	  	else
	  		arr = [true]
	  		dimensions[0] > dimensions[1] ? arr << 'landscape' : arr << 'portrait' 
	  	end
	  end
  	arr
  end
    
  def upload_img(file, loc = 'images')
  	tmpfile = file[:tempfile] 
  	name = file[:filename]
  	type = file[:type].to_s

  	unless type.include? 'image'
	  	flash[:alert] = 'Unsupported file type for image. ' + type
	  	redirect back
	  else
    	time = Time.now.to_s
    	image_name = time + name
    	image_name.gsub!(/\s/, '')
    	File.open(File.join(Dir.pwd,"public/uploads/#{loc}/" , image_name), "wb") do |f|
      	while(blk = tmpfile.read(65536))
          f.write(blk)
        end
      end
      flash[:alert] = 'Successful image upload '
    end    
    image_name
  end
    
end

get '/dashboard/?' do
  authenticate
  @blogposts = Blogpost.all(:order => [ :id.desc ])
  @pgtitle = 'Dashbaord'
  erb :dashboard, layout: :admin 
end

namespace '/admin' do
	before { authenticate }
	
	get '/readme/?' do
		@pgtitle = 'Readme'
		erb :readme, layout: :admin
	end
	
	['/new/post/?', '/invalid/post/?', '/invalid/size/'].each do |path|
 	 	get path do
		  @pgtitle = 'New Post'
		  flash[:alert] = 'You must have at least one field completed.' if path == '/invalid/post/?'
		  @title = session[:title] if session[:title]
		  @article = session[:article] if session[:article]
		  session[:title], session[:article] = nil, nil if session[:title] || session[:article]
		  erb :new_post, layout: :admin
		end
	end
	
	get '/new/banner/?' do
		@pgtitle = 'Banners'
		@banners = Banner.all(:order => [:id.desc])
		erb :new_banner, layout: :admin
	end
	
	post '/new/banner/?' do
		flash[:alert] = ''
		
		if params[:image]
			image = upload_img(params[:image], 'banners')
		  size = right_size("public/uploads/banners/", image, 960, 375) 
	  
		  if size[0] == false
		  	session[:title] = params[:title]
		  	session[:article] = params[:article]
		  	flash[:alert] = "Invalid size! Image must be equal to #{size[1]} x  #{size[2]}."	
		  	redirect back
		  else
			  banner = Banner.create(image: image, link: params[:link])
			  flash[:alert] = 'Image upload was successful.'	if banner.saved?
		  end
		end
			redirect '/admin/new/banner/'
	end
	
	get '/delete/banner/:id/?' do
		banner = Banner.get(params[:id]) 
		if banner  
			gone = banner.destroy
			flash[:alert] = "Banner has been destroyed." if gone
		else
			flash[:alert] = 'Banner does not exist. Contact Admin.'
		end
		redirect '/dashboard'
	end
	
	post '/new/post/?' do
		flash[:alert] = ''
		
		if params[:image]
			image = upload_img(params[:image])
		  size = right_size("public/uploads/images/", image) 
	  
		  if size[0] == false
		  	session[:title] = params[:title]
		  	session[:article] = params[:article]
		  	flash[:alert] = "Invalid size! Image must be equal to or smaller than #{size[1]} x  #{size[2]}."	
		  	redirect "/admin/invalid/size/"
		  else
			  	orientation = size[1]
		  end
		end
		
	  title = params[:title]
	  article = params[:article]	
	    
	  if params[:video_url]
	  	url = (params[:video_url]).validate_url 
	  	url[0] ? video = url[1] : video = nil 
	  end
	  
    arr = [] << title << article << image << video
    arr.delete("")
    arr.compact!
    redirect '/admin/invalid/post/' if arr.empty? 
	  
	  if params[:feature]
	  	if params[:feature_thumb] 
	  		thumb = upload_img(params[:feature_thumb], 'thumbs')
	  		thumbSize = right_size("public/uploads/thumbs/", thumb)
	  		if thumbSize[0] == false
			  	session[:title] = params[:title]
			  	session[:article] = params[:article]
			  	flash[:alert] = "Invalid size! Image must be equal to or smaller than #{size[1]} x  #{size[2]}."	
			  	redirect "/admin/invalid/size/"
			  end
			else
				flash[:alert] = "Invalid! Feature Thumb must be present for feature."
				redirect back 
	  	end
	  	feature = params[:feature]
	  else
	  	feature = false
	  end	  
	  
	  if params[:production] == 'true'   
	  	production_type, production = params[:production_type], params[:production] 
	  else
	    production_type, production = nil, false
	  end
	  
	  blogpost = Blogpost.create(title: title, article: article, image: image, video_url: video, feature: feature, feature_thumb: thumb, production: production, production_type: production_type, image_orientation: orientation) 
	  flash[:alert] += 'The Post was successful.' if blogpost.saved?
	  redirect 'dashboard'
	end
	
	get '/edit/post/:id/?' do
		@title = session[:title] if session[:title]
		@article = session[:article] if session[:article]
		session[:title], session[:article] = nil, nil if session[:title] || session[:article]

	  @blogpost = Blogpost.get(params[:id])
	  @pgtitle = 'Edit'
	  erb :edit_post, :layout => :admin
	end
	
	post '/edit/post/:id/?' do 
		if params[:image]
			image = upload_img(params[:image])
			size = right_size("public/uploads/images/", image) 
			
		  if size[0] == false
		  	session[:title] = params[:title]
		  	session[:article] = params[:article]
		  	flash[:alert] = "Invalid size! Image must be equal to or smaller than #{size[1]} x  #{size[2]}."	
		  	redirect back
		  else
			  orientation = size[1]
		  end
		end
		
		title = params[:title]
	  article = params[:article]
	  video_url = params[:video_url].strip
	  
	  unless video_url.empty? || video_url == ""
	  	url = (video_url).validate_url 
	  	url[0] ? video = url[1] : video = nil 
	  else 
	  	video = nil 
	  end
	  
    arr = [] << title << article << image << video
    arr.delete("")
    arr.compact!
    
    if arr.empty? 
    	flash[:alert] = 'Ivalid Post! You must have at least one field completed. '
    	redirect back
    end
    
    blogpost = Blogpost.get(params[:id])
		
	  if params[:feature]
	  	if params[:feature_thumb] 
	  		thumb = upload_img(params[:feature_thumb], 'thumbs')
	  		thumbSize = right_size("public/uploads/thumbs/", thumb)
	  		if thumbSize[0] == false
			  	session[:title] = params[:title]
			  	session[:article] = params[:article]
			  	flash[:alert] = "Invalid size! Image must be equal to or smaller than #{size[1]} x  #{size[2]}."	
			  	redirect "/admin/invalid/size/"
			  end
			else
				if blogpost.feature_thumb
					thumb = blogpost.feature_thumb
				else
					flash[:alert] = "Invalid! Feature Thumb must be present for feature."
					redirect back 
				end
	  	end
	  	feature = params[:feature]
	  else
	  	feature = false
	  end	  
	  
	  if params[:production] == 'true'   
	  	production_type, production = params[:production_type], params[:production] 
	  else
	    production_type, production = nil, false
	  end
	 
	  if blogpost.image && image != nil
	  	oldImg = blogpost.image 
	  end
	  
	  image = blogpost.image if image.nil?
	  thumb = blogpost.feature_thumb if thumb.nil?
	  
	  if feature == false && blogpost.feature_thumb # || blogpost.feature_thumb && blogpost.feature_thumb != thumb 
	  	oldThumb = blogpost.feature_thumb
	  end
	  
	  orientation = blogpost.image_orientation if orientation.nil?
	  	
	  blogpost = blogpost.update(title: title, article: article, image: image, video_url: video, feature: feature, feature_thumb: thumb, production: production, production_type: production_type, image_orientation: orientation)
	  
	  ### Need to be hooks 
	  if oldImg && blogpost
	  	Dir.chdir('public/uploads/images')
      File.delete(oldImg)
      Dir.chdir("../../../")
    end
    
    if oldThumb && blogpost
	  	Dir.chdir('public/uploads/thumbs')
      File.delete(oldThumb)
      Dir.chdir("../../../")
    end
    
	  @pgtitle = 'Edit Post'
	  #redirect "/post/#{params[:id]}"
	  redirect '/dashboard/'
	end
	
	get '/delete/post/:id/?' do 
		blogpost = Blogpost.get(params[:id])
		unless blogpost.title == 'Biography'
			gone = blogpost.destroy
			flash[:alert] = "Post has been destroyed." if gone
		else
			flash[:alert] = 'You can not delete Your Biography.'
		end
		redirect '/dashboard'
	end
	
	get '/edit/biography/?' do
		@biography = Blogpost.first(title: 'Biography')
		@pgtitle = 'Edit Biography'
	  erb :edit_bio, :layout => :admin
	end

end