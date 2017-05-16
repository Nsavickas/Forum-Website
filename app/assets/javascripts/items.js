$(document).ready(function() {
	
	$("input[name='food']").on('change', function() {
			if($(this).is(':checked')) {
	    	$(".food").show();
			} else {
	    	$(".food").hide();
			}
	}); 
		
	$("input[name='vehicles']").on('change', function() {
			if($(this).is(':checked')) {
	    	$(".vehicles").show();
			} else {
	    	$(".vehicles").hide();
			}
	}); 
		
	$("input[name='luxury']").on('change', function() {
			if($(this).is(':checked')) {
	    	$(".luxury").show();
			} else {
	    	$(".luxury").hide();
			}
	}); 
		
	$("input[name='clothing']").on('change', function() {
			if($(this).is(':checked')) {
	    	$(".clothing").show();
			} else {
	    	$(".clothing").hide();
			}
	}); 	
});
