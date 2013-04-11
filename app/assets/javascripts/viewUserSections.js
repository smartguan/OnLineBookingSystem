// // for adding the users details 

function init_view_user_sections() {
	$('#section-template').hide();		//hide template
	getViewUserSections();				//populate table
}

function getViewUserSections() { 
	post_json_request("/registrations/viewEnrolledSections", {}, function(data){handleViewSectionsResponse(data)})
}

function dropSectionButtonClick(title) {
	return 	post_json_request("/Registrations/register", { section_name:title }, function(data) { return handleRegisterSectionResponse(data); });
}

function handleViewSectionsResponse(data) {
	var error_code = data.errCode;
	var sections = data.sections;
	var error_msg = getErrorMessage(error_code);

	function validSectionsExist(errCode, sections) { return (errCode==1 && sections.length > 0 ); }

	$('#err-message').empty();
	$('#err-message').append(error_msg);

	if( validSectionsExist(error_code, sections) ) {
		for(i=0; i<sections.length; i++) { 
			var inputSection = new Section(sections[i], dropSectionButtonClick, "Drop" );
			$('#user-sections').append( inputSection.renderHTML().show() );
		}
		return true;
	}
 	return false;
}

