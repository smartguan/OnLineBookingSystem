
/////////////////////////////////////////////////////////////
///////////////// Populating User Info Repsonses ////////////
/////////////////////////////////////////////////////////////
function handleViewSectionsResponse(data) {

  var error_msg = translateErrCode(data.errCode);
  var validSections = data.errCode==1 && data.sections.length > 0;

  if( validSections ) {
    Sections.renderHTML(data.sections);
  }
  else {
    var no_section_msg = $("#no-enrolled-sections-message").clone().removeAttr('id').show();
    $(enrolledSectionsId).empty().append( no_section_msg);
  }
  return false;
}
/////////////////////////////////////////////////////////////
////////////////////  Update Submissions ////////////////////
/////////////////////////////////////////////////////////////
function handleUpdateResponse(data) {
  var not_ok_id = getStatusID(false, "update-user-errors");
  var error_msg = translateErrCode(data.errCode);
  $(not_ok_id).fadeOut(200);
  $(not_ok_id).find("#update-user-err-message").html(error_msg);

  if(data.errCode == 1 ) {
    var ok_id = getStatusID(true, "update-user-success");
    $(ok_id).fadeIn(600);
    setTimeout(function(){window.location.replace("/Users/show");},600);
    return true;
  }
  else {
    $(not_ok_id).fadeIn(400);
    return false;
  }
}

function handleUpdatePasswordResponse(data) {
  var not_ok_id = getStatusID(false, "update-password-errors");
  var error_msg = translateErrCode(data.errCode);
  $(not_ok_id).fadeOut(200);
  $(not_ok_id).find("#update-password-err-message").html(error_msg);

  if(data.errCode == 1 ) {
    var ok_id = getStatusID(true, "update-password-success");
    $(ok_id).fadeIn(600);
    setTimeout(function(){window.location.replace("/Users/show");},600);
    return true;
  }
  else {
    $(not_ok_id).fadeIn(400);
    return false;
  }
}

///////////////////////////////////////////////////////////////////////
/////////////////////////// Login User Functions //////////////////////
///////////////////////////////////////////////////////////////////////

function handleLoginUserResponse(data)  {
  var error_message = translateErrCode(data.errCode);
  $("#login-user-err-message").empty();
  $("#login-user-err-message").append(error_message);

  if (data.errCode!=1) {
     $("#login-user-errors").fadeIn(200);
     return data.errCode;
  }
  else {
    $("#login-user-success").fadeIn(300);
    return 1;
  }
}

function handleLogoutResponse(data) {
  alert("logging out");
  window.location.href = '/';
  return false; 
}


function handleProfileResponse(data) {
  var error_code = data.errCode;
  var error_msg = translateErrCode(error_code);
  $('#err-message').append(error_msg);

  if(error_code==1) {
    var isField_show = false;
    var isField_update = true;
    User.renderHTML("show", data.user, isField_show);
    User.renderHTML("update", data.user, isField_update);
    var fullname = data.user.first + " " + data.user.last;
    $("#user-name-navbar").html(fullname);
    return true;
  }
  return false;
}

function handleCreateUserResponse(data) {
  var not_ok_id = getStatusID(false, "create-user-errors");
  var error_msg = translateErrCode(data.errCode);
  $(not_ok_id).fadeOut(200);
  $(not_ok_id).find("#create-user-err-message").html(error_msg);

  if(data.errCode == 1 ) {
    var ok_id = getStatusID(true, "create-user-success");
    $(ok_id).fadeIn(600);
    setTimeout(function(){window.location.replace("/Users/show");},600);
    return true;
  }
  else {
    $(not_ok_id).fadeIn(400);
    return false;
  }
}


function handleRegisterSectionResponse(data) {
 var error_code = data.errCode;
 var status_msg = translateErrCode(error_code);
 // $('#err-message').empty();
 // $('#err-message').append(status_msg);
  
 if(error_code == 1) {
   alert("Success");handleUpdateResponse
 }
 else { 
   alert('failure');
 }
 return false;
}

function removeModal(modal_id) {
  alert("in here.");
  modal_id = ".modal#" + modal_id;
  $(modal_id).modal('hide');
  $('body').removeClass('modal-open');
  $('.modal-backdrop').remove();
}


function getStatusID(success, id) {
  var alert_type = (success) ? ".alert.alert-success" : ".alert.alert-error";
  return alert_type + "#" + id;
}