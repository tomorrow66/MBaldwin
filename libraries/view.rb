# View helpers:
#
# active('my_url')
# Accepts a string or an array of strings.
# Returns 'active' if the path arguments matches the current request path.
# Useful for sticky/active links.
#
# <%= alert %>
# Easy way to display flash[:alert] messages
# In the route handler:
#   flash[:alert] = 'Welcome back!'
# And in the view:
#   <%= alert %>
# Will produce:
#   "<div id='alert'>Welcome back!</div>"
#
# hidden
# Useful inside an inline style:
#  style="<%= hidden unless @user.admin? %>"
#  => style="display: none;"

helpers do
	
	def active path
		path = Array[path] unless path.kind_of? Array
		match = false
		path.each {|p| match = true if request.path_info.include? p }
		'active' if match
	end
	
	def alert
		"<div id='alert'>#{flash[:alert]}</div>" if flash[:alert]
	end
	
	def hidden
		'display: none;'
	end
	
end