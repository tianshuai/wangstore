;(function($) {
	$.notifybar = {};
	$.show_notify_bar = function(options) {
		var opts = $.extend({}, $.notifybar.defaults, options);
		if(!$('.jbar').length){
			timeout = setTimeout('$.remove_notify_bar()',opts.time);
			var _message_span = $(document.createElement('span')).addClass('jbar-content').html(opts.message);
			_message_span.css({"color" : opts.color});
			var _wrap_bar;
			(opts.position == 'bottom') ? 
			_wrap_bar	  = $(document.createElement('div')).addClass('jbar jbar-bottom jbar_ok'):
			_wrap_bar	  = $(document.createElement('div')).addClass('jbar jbar-top '+opts.className+'') ;
            // _wrap_bar.attr('id','jbar');
			_wrap_bar.css({"background-color" 	: opts.background_color});
			if(opts.removebutton){
				var _remove_cross = $(document.createElement('a')).addClass('jbar-cross');
				_remove_cross.click(function(e){$.remove_notify_bar();});
			}
			else{	
				_wrap_bar.css({"cursor"	: "pointer"});
				_wrap_bar.click(function(e){$.remove_notify_bar();});
			}
			var $container = opts.container ? $(opts.container) : $('#doc');
			_wrap_bar.append(_message_span).append(_remove_cross).hide().insertBefore($container).fadeIn('fast');
		}
	};
	var timeout;
	$.remove_notify_bar 	= function() {
		if($('.jbar').length){
			clearTimeout(timeout);
			$('.jbar').fadeOut('fast',function(){
				$(this).remove();
			});
		}	
	};
	$.notifybar.defaults = {
		background_color 	: '#FFFFFF',
		color 				: '#000',
		position		 	: 'top',
		removebutton     	: true,
		time			 	: 5000
	};
})(jQuery);