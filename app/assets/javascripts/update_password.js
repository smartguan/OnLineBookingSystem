/////////////////////////////////////////////////////////////////////
////////////////////// Password Submission JS/////////////////////////
//////////////////////////////////////////////////////////////////////

function init_password_update() {
	$('#submit-password-update').click( function() { sendPasswordUpdateRequest(); }  );
	return true;
}

function sendPasswordUpdateRequest() {
	var old_password = $('#password-old').val();
    var new_password = $('#password-new').val();
    var confirm_new_password = $('#password-new-confirmation').val();
    var update_password_dict = {prev_password:old_password, password:new_password, password_confirmation:confirm_new_password};
	post_json_request("/users/update_password", update_password_dict, function(data) { return handleUpdatePasswordResponse(data); });
	return false;
}

function handleUpdatePasswordResponse(data) {
	var error_code = data.errCode;
	var sections = data.sections;
	var error_msg = getErrorMessage(error_code);

	$('#err-message').empty();
	$('#err-message').append(error_msg);

 	return false;
}