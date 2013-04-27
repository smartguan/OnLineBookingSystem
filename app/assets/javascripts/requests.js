function sendUpdateUserRequest() {
	$("#update-user-err-message").empty();
	var inputUser = new User();
	post_json_request("/Users/update", inputUser.collectInput("update"), handleUpdateResponse);
	return false;
}
function sendLoginUserRequest() {
  $("#login-user-errors").fadeOut(100);
  var login_user = { email:getFormInput("login","email"),  password:getFormInput("login","password") };
  post_json_request("/Users/login", login_user, handleLoginUserResponse);
  return false;
}
function showConfirmation(event) {
  var confirm_drop_msg = "Are you sure you wish to drop this class?"
  var dropped_class = confirm(confirm_drop_msg);
  if(dropped_class) {
    post_json_request("/Registrations/drop", { section_id: event.data.section_id  }, handleRegisterSectionResponse );
    var section_id = "#section-" + event.data.section_id;
    $(".section").find(section_id).parent().fadeOut(500).remove();  //hella bootlegged
  }
  return true;
}

function dropSectionButtonClick(event) {
  return  post_json_request("/Registrations/drop", { section_id: event.data.section_id  }, handleViewSectionsResponse );
}



/////////////////////////////////////////////
///////// Create User Functions /////////////
/////////////////////////////////////////////
function sendCreateUserRequest() {
  $("#create-user-err-message").empty();
  var inputUser = new User();

  post_json_request("/MemberStudents/add", inputUser.collectInput("create"), handleCreateUserResponse);
  return false;
}
