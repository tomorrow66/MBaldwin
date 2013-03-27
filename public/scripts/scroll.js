$(function() {

    var $sidebar   = $("nav"), 
        $window    = $(window),
        offset     = $sidebar.offset(),
        width	   = $window.width();

    $window.scroll(function() {
        if ($window.scrollTop() > offset.top) {
						$sidebar.addClass('fixed');
						if (width < 480) {
							$('.scrollHide').hide();
						}
        } else {
						$sidebar.removeClass('fixed');
						$('.scrollHide').show();
        }
    });
    
});