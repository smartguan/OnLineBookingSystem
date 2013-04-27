function handleViewSectionsResponse(data) {
  var enrolledSectionsId = "#show-enrolled-sections";

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
function handleRegisterSectionResponse(data) {
 var error_code = data.errCode;
 var status_msg = translateErrCode(error_code);
 // $('#err-message').empty();
 // $('#err-message').append(status_msg);
  
 if(error_code == 1) {
   alert("Success");
 }
 else { 
   alert('failure');
 }
 return false;
}


function handleUpdateResponse(data) {
  if(data.errCode == 1 ) {
    //to be changed later to #update-user-success
    $("#create-user-success").fadeIn(300);
    setTimeout( function(){window.location.replace("/");}, 1600);
    return 1;
  }
  else {
    alert(translateErrCode(data.errCode))
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

function handleProfileResponse(data) {
  var error_code = data.errCode;
  var error_msg = translateErrCode(error_code);
  $('#err-message').append(error_msg);

  if(error_code==1) {
    User.renderHTML("show", data.user);
    var fullname = data.user.first + " " + data.user.last;
    $("#user-name-navbar").html(fullname);
    return true;
  }
  return false;
}



function handleCreateUserResponse(data) {
  var error_message =  translateErrCode(data.errCode);
  $("#create-user-errors").fadeOut(300);
  $("#create-user-err-message").html(error_message);
  
  if(data.errCode!=1) {
     $("#create-user-errors").show();
     return data.errCode;
  }
  else {
    $("#create-user-success").fadeIn(300);
    setTimeout( function(){window.location.replace("/");}, 1600);
    return 1;
  }
}