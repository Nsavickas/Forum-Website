/*
$(document).ready(function() {
	$(".user_notifications_table tr").on('click', function(event) {
		var element_id = event.target.id.to_s;
		alert('element_id');
		var object_id = element_id.slice(-1);
		alert('object_id');
		$.ajax({
        url: "/notifications/" + object_id,
        type: "PUT",
        data:   { viewed: @viewed},
        success: (data) ->
            alert ("success")
            return false
        error:(data) ->
    return false
     })
    else
        alert("no")
    return
	});

});
*/