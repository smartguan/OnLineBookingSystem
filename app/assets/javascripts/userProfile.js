//////////////////////////////////////////////////////////////////////
////////////////////// User Information JS ///////////////////////////
//////////////////////////////////////////////////////////////////////

function handleProfileResponse(data) {
	var error_code = data.errCode;
	var error_msg = getErrorMessage(error_code);
	$('#err-message').append(error_msg);
	

	function renderUserHTML(userJSON) {
		var	username = new Name(userJSON.first, userJSON.last);
		$('#user-info').find('#user-name').append(username.fullname);
		$('#user-info').find('#user-email').append(userJSON.email);
		$('#user-info').find('#user-dob').append(userJSON.dob);
		$('#user-info').find('#user-zip').append(userJSON.zip);

		$('#nav-user-name').append(username.fullname);	//add to user nav
		return false;
	}

	if(error_code==1) {
		renderUserHTML(data.user);
		return true;
	}
 	return false;
}

var Name = function(first,last) {
	this.first = first;
	this.last = last;
	this.fullname = first + " " + last;
}

function getUserInfo() {
	post_json_request(
		"/users/profile", {}, 
		function(data) {return handleProfileResponse(data)}, 
        function(error) {alert("Error")}
        ); 
}

function getErrorMessage(errCode) {
	switch (errCode) {
		case 104: 	return "Password Must Contain 6-32 Characters";
		case 107: 	return "E-mail Already Registered.";
		case 109: 	return "Password and Password Confirmation DO NOT match";
		case 1: 	return "";
		default: 	return "unknown error has occurred"
	}
}

