$('document').ready(function() {
	$("input[name='likes-checkbox']").on('change', function() {
		if ($(this).is(':checked')) {
			$('.likers').children().removeClass('hide');
		} else {
			$('.likers').children().addClass('hide');
		}
	});
  
  $('[data-toggle="tooltip"]').tooltip();
	
});



