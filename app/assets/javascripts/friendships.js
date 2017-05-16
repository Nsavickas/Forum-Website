$('document').ready(function() {
	$('#mutual-friends-btn').on('click', function() {
		$('#mutual-friends').removeClass('hide');
		$('#incoming-requests').addClass('hide');
		$('#outgoing-requests').addClass('hide');		
	});
	$('#incoming-requests-btn').on('click', function() {
		$('#mutual-friends').addClass('hide');
		$('#incoming-requests').removeClass('hide');
		$('#outgoing-requests').addClass('hide');
	});
	$('#outgoing-requests-btn').on('click', function() {
		$('#mutual-friends').addClass('hide');
		$('#incoming-requests').addClass('hide');
		$('#outgoing-requests').removeClass('hide');
	});
});