['/index/?', '/?', '/home/?', '/index.html/?', '/home.html/?'].each do |path|
  get path do
    @path = 'index'
    @features = Blogpost.all(feature: true, :order => [:id.desc])
    @banners = Banner.all(:order => [:id.asc])
    @biography = Blogpost.first(title: 'Biography')
    erb :index
  end
end

get '/productions/?' do
  @path = 'productions'
  @family = Blogpost.all(production_type: 'family').reverse
  @delight = Blogpost.all(production_type: 'delight').reverse
  @teach = Blogpost.all(production_type: 'teach').reverse
  erb :productions
end

get '/biography/?' do
  @path = 'biography'
  @biography = Blogpost.first(title: 'Biography')
  erb :biography
end

get '/latest/?' do
  @path = 'latest'
  @blogposts = Blogpost.all(:order => [ :id.desc ])
  erb :latest
end

get '/contact/?' do
  @path = 'contact'
  erb :contact
end

get '/post/:id/?' do
  @blogpost = Blogpost.get(params[:id]) 
  erb :post
end

## get '/posts/filter/:type/?' do
## 		params[:type] == "video" ? type = "video_url" : type = params[:type]
## 		@blogposts = Blogpost.filter(type)
## 		if @blogposts
## 			erb :index
## 		else
## 			flash[:alert] = "There seems to be nothing there? Here is everything instead."
## 			redirect "/"
## 		end
## end