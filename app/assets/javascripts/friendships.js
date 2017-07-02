$('document').ready(function() {
	$('#mutual-friends-btn').on('click', function() {
		$('#mutual-friends-btn').addClass('nav-selected');
		$('#outgoing-requests-btn').removeClass('nav-selected');
		$('#incoming-requests-btn').removeClass('nav-selected');

		$('#mutual-friends').removeClass('hide');
		$('#incoming-requests').addClass('hide');
		$('#outgoing-requests').addClass('hide');
	});
	$('#incoming-requests-btn').on('click', function() {
		$('#incoming-requests-btn').addClass('nav-selected');
		$('#mutual-friends-btn').removeClass('nav-selected');
		$('#outgoing-requests-btn').removeClass('nav-selected');

		$('#mutual-friends').addClass('hide');
		$('#incoming-requests').removeClass('hide');
		$('#outgoing-requests').addClass('hide');
	});
	$('#outgoing-requests-btn').on('click', function() {
		$('#outgoing-requests-btn').addClass('nav-selected');
		$('#incoming-requests-btn').removeClass('nav-selected');
		$('#mutual-friends-btn').removeClass('nav-selected');

		$('#mutual-friends').addClass('hide');
		$('#incoming-requests').addClass('hide');
		$('#outgoing-requests').removeClass('hide');
	});
});
