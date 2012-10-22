jQuery(function()
{
		$('.hideshow').click(function(){
			$(this).parent().next('.accordian').fadeToggle('slow'); // options: slideToggle, toggle
				return false;
	      });
	      
   $('.check').click(function(){
   			$(this).parent().next('.accordian').fadeToggle('slow'); // options: slideToggle, toggle
      });
	      
    $('a.collapse').click(function(){
			$(this).hide(); // options: slideUp, fadeOut
		});
		
		$('.delete').click(function(){
		  if (!confirm('Are you sure?'))
		    { return false; }
		});
		
		 $('a.load').click(function(){
				$.ajax({
				  url: "load/test",
				  cache: false
				}).done(function(html) {
				  $("#results").append(html);
				});
				return false;
			});
	
	$('.tabShow').live('click', function()
	{
		var id = $(this).attr("id");
		var p = 'li.ovAuto.';
		var cl = p + id;
		var last = cl + ':visible:last'
		
		$('div.tabs a').removeClass('invert');
		$(this).toggleClass('invert');
		$('li.ovAuto:visible').fadeOut(500, 
		function(){
	 		$(cl).fadeIn(500);
	 		$(last).css("border-bottom", "solid 0px transparent")
	 	});
	 	
		return false;
	});
	
	if (window.location == 'http://margaretbaldwin.com/productions')
		{
			$('li.ovAuto.family:visible:last').css("border-bottom", "solid 0px transparent")
		}

//	var onResize = function() {
//						var win = $(window).width()
//						if (win < 801) {
//							$("img.banner").replaceWith('<img src="/images/mbanner.jpg" class="banner">');						
//							}
//						else {
//							$("img.banner").replaceWith('<img src="/images/banner.jpg" class="banner">');
//							}
//							
//					}
//	
//	$(document).ready(onResize);
//
//	$(window).bind('resize', onResize);
	
});