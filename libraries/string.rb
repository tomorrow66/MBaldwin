# String extensions:
#
# s = 'hello world'
#
# s.is_numeric? => false
#
# s.titleize => "Hello World"
#
# s.truncate(1) => "hello..."
# Option: end_string (defaults to '...')

String.class_eval do
	
	def is_numeric?
		true if Float(self) rescue false
	end
		
	def titleize
		title = ''
		self.split(' ').each {|s| title << s.capitalize + ' ' }
		title
	end
	
	def truncate word_count = 100, end_string = '...'
		return if self == nil
		words = self.split()
		words[0..(word_count-1)].join(' ') + (words.length > word_count ? end_string : '')
	end
	
	 def validate_url
  	if /^https?:\/\/vimeo.com\/\d*/ =~ self
	  	if self.include? "http"
	  		self.gsub!(/^https?:\/\/vimeo.com\//, "")
	  	end
	  	[true, self]
	  elsif /\d{1,10}/ =~ self
	  	[true, self]
	  else
	  	[false, self]
	  end
   end
	
	 def format_text
    unless self.nil?
	  	self.create_links
		  self.style_text
		  self.add_tags
		end
	end
	
	def style_text
		arr = ["strike", "underline", "strong", "italic"]
		arr.each do |s|
			found = self.split(/\]\s?/).find_all {|u| u =~ /#{s}(.)*/}
			found.each do |old|
			old.strip!
			old.gsub!(/[\n\r]*/, "").gsub!(/^(.)*\[/, "#{s}\[")

			 new = old.gsub(/#{s}\[/, "")
			 self.gsub!("#{old}", "<span class='#{s}'>#{new}</span>") if s == "strike" 
			 self.gsub!("#{old}", "<span class='#{s}'>#{new}</span>") if s == "underline"
			 self.gsub!("#{old}", "<strong>#{new}</strong>") if s == "strong"
			 self.gsub!("#{old}", "<em>#{new}</em>") if s == "italic"
			 puts self if s == "underline"
			end
		end
		self.gsub!(/>\]/, ">")
		self
	end
	
	def create_links
		 # Searches the var for ~ and creates links using the words between them and the web address that immediately follows
	   title = self.scan /~[\w\d\s+\.\/\!\?\,\@\*\:\;\"\'\#\&]*~/
	   href = self.split(/\s+/).find_all { |u| u =~ /^https?:/ }
	   if (title && href)
		   hash = Hash.new 
		   title.each_with_index {|t,i| hash[t] = href[i]}
		   hash.each_pair do |t, h|
			   unless hash.empty?
			     link = "<a href='#{h}' >#{t}</a>"
			     self.gsub!("#{h}",'')
			     self.gsub!("#{t}","#{link}")
			   end
			end
		  self.gsub!(/~/,'')
		 end
		 self
	end
  
  def add_tags
		# Searches the var til end of line, splits and appends paragraph and list item tags
		  arr = self.split /^(.*)$/
		  tags = ""
		  if arr
			  arr.each do |p| 
			  	p.strip!
			  	
			  	ol = /^\d\)?(.*)$/.match(p)
			  	ul = /^\*(.*)$/.match(p)
			  	
			  	if (ul || ol)
						if ul			  	
				  		p.gsub!(/^\*\s?/, "")
				  		tags += "<ul><li>#{p}</li></ul>"
				  	elsif ol	
				  		p.gsub!(/^\d*[\s?\)?]*/, "")
				  		tags += "<ol><li>#{p}</li></ol>"
				  	end
			  	else
			  	  unless p.empty?
			  		  tags += "<p>#{p}</p>" 
			  	  end 
			  	end
			  	tags.strip!
			  end
			  
			  tags.gsub!(/\<p\>\<\/p\>/, "")
 			  tags.gsub!(/\<p\>\<p\>/, "")
			  tags.gsub!(/<\/p><\/p>/, "")
			  tags.gsub!(/<\/ul><ul>/, "")
			  tags.gsub!(/<\/ol><ol>/, "")
			  
			else 
				tags = "<p>#{self}</p>" 
			end
			tags
	end
end