# CoffeeScript files will be converted to JavaScript files:
# <script type="text/javascript" src="/scripts/interactions.coffee"></script>
  	
jQuery ->
	$('a.delete').click -> return false unless comfirm 'This will be deleted permanently!!!'  	