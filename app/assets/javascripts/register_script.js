$('document').ready(function() {
	$('.register_now').click(function() {
		console.log('Register Javascript activated');
		//$('body').empty().load("/users/new");
		$('.welcome_page').empty();
		$('#register_form').css('visibility', 'visible');
	});
});
