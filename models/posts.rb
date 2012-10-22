class Blogpost
  include DataMapper::Resource
  
  property    :id,          Serial
  property    :deleted_at,  ParanoidDateTime
  timestamps  :at

  property  :title,         		String, length: 400
  property  :article,       		String, length: 3300
  
  property 	:image, 						String, length: 120
  property  :image_orientation, String
  
  property 	:video_url, 				String, length: 400
  
  property 	:feature, 					Boolean, :default  => false
  property  :feature_thumb, 		String, length: 120

  property 	:production, 				Boolean, :default  => false
  property 	:production_type, 	String
  
  
  def self.filter(arg)
  	if (arg == 'video_url' || arg == 'article' || arg == 'image') 
	  	collection = all
	  	arr = []
	  	collection.each do |f|
	  		arr << f if eval("f.#{arg}")
	  	end
	  	arr
	  else
	  	false
	  end
  end
  
  before :destroy do |post|
  	if post.image
      Dir.chdir("public/uploads/images/")
      File.delete(post.image)
      Dir.chdir("../../../")
    end
    
    if post.feature_thumb
      Dir.chdir("public/uploads/thumbs/")
      File.delete(post.feature_thumb)
      Dir.chdir("../../../")
    end
  end
    
end

class Banner
  include DataMapper::Resource
  property    :id,          Serial
  
  property 		:image, 				String, length: 120
  property 		:link, 					String, length: 300
  
  before :destroy do |banner|
  	if banner.image
      Dir.chdir("public/uploads/banners/")
      File.delete(banner.image)
      Dir.chdir("../../../")
    end
  end
  
end

