$('document').ready(function() {
	$('#recent-posts-btn').on('click', function() {
		$('#recent-posts').removeClass('hide');
		$('#recent-comments').addClass('hide');
		$('#recent-likes').addClass('hide');
	});
	$('#recent-comments-btn').on('click', function() {
		$('#recent-posts').addClass('hide');
		$('#recent-comments').removeClass('hide');
		$('#recent-likes').addClass('hide');
	});
	$('#recent-likes-btn').on('click', function() {
		/*var current_href = window.location.href();
		$.ajax({
			type: 'GET', 
			url: current_href + '/likes',
			success: function(result) {
				
			}
		});*/
		
		$('#recent-posts').addClass('hide');
		$('#recent-comments').addClass('hide');
		$('#recent-likes').removeClass('hide');		
	});
});
