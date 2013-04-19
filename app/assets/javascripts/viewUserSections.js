//Javascript Code for Handling User's Registrations

///////////////////////////////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////// Initializers //////////////////////////////////////////
// ///////////////////////////////////////////////////////////////////////////////////////////////////////
// function init_view_user_sections() {
// 	$('#section-template').hide();		//hide template
// 	getViewUserSections();				//populate table
// }
// function init_view_sections() {
// 	$('#section-template').hide();		//hide template
// 	getScheduleRequest();				//populate table
// 	$('.section-info').hide();			//default view is hidden
// }


// ///////////////////////////////////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////// Objects for Rendering sections ////////////////////////////////
// ///////////////////////////////////////////////////////////////////////////////////////////////////////////
// var Section = function(sectionJSON, clickFunction, buttonTitle) {
// 	this.title = sectionJSON.name;
// 	this.instructor = sectionJSON.teacher;
// 	this.description = sectionJSON.description;

// 	this.date_start = parseDate_reservation(sectionJSON.start_date);
// 	this.date_end = parseDate_reservation(sectionJSON.end_date);
// 	this.date_range = new Range(this.date_start, this.date_end);
	
// 	this.time_start = parseTime_reservation(sectionJSON.start_time);
// 	this.time_end = parseTime_reservation(sectionJSON.end_time);
// 	this.time_range = new Range(this.time_start, this.time_end);	
	
// 	this.waitlist_frac = new Frac(sectionJSON.waitlist_cur, sectionJSON.waitlist_max);
// 	this.enroll_frac = new Frac(sectionJSON.enroll_cur, sectionJSON.enroll_max);

// 	this.renderHTML = function() {
// 		var $section_clone = $('#section-template').clone();
// 		$section_clone.removeAttr('id').addClass('section');

// 		$section_clone.find('.instructor').append(this.instructor);
// 		$section_clone.find('.description').append(this.description);
// 		$section_clone.find('.time').append(this.time_range.string);
// 		$section_clone.find('.date').append(this.date_range.string);
// 		$section_clone.find('.waitlisted').append(this.waitlist_frac.string);
// 		$section_clone.find('.enrolled').append(this.enroll_frac.string);
		
// 		$section_clone.find('a.title').append(this.title).click(function() {$(this).siblings().slideToggle();});

// 		$section_clone.find('button').append(buttonTitle);

// 		$section_clone.find('button').on("click", {title:this.title}, function(event) { clickFunction(event.data.title) });		
// 		return $section_clone;
// 	}
// }
// var Range = function(start, end) {
// 	this.start = start;
// 	this.end = end;
// 	this.string = (this.start + " - " + this.end);
// }

// var Frac = function(numerator, demoninator) {
// 	this.numerator = numerator;
// 	this.demoninator = demoninator;
// 	this.string = (this.numerator + " / " + this.demoninator);
// }


// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ////////////////////////////////////////////// Request Functions ///////////////////////////////////////////
// ////////////////////////////////////////////////////////////////////////////////////////////////////////////

// //On Load Requests
// // function getViewUserSections() { 
// // 	return post_json_request("/Registrations/viewEnrolledSections", {}, handleViewSectionsResponse);
// // }
// // function getScheduleRequest() { 
// // 	return post_json_request("/Registrations/getSchedule", {}, handleGetScheduleResponse );
// // }

// //Button Click Triggers
// function dropSectionButtonClick(title) {
// 	return 	post_json_request("/Registrations/drop", { section_name:title }, handleRegisterSectionResponse );
// }
// function registerButtonClick(title) {
// 	return 	post_json_request("/Registrations/register", { section_name:title }, handleRegisterSectionResponse);
// }

// ////////////////////////////////////////////////////////////////////////////////////////////////////////
// ////////////////////////////////////// Response Handlers ///////////////////////////////////////////////
// ////////////////////////////////////////////////////////////////////////////////////////////////////////

// function handleViewSectionsResponse(data) {
// 	var error_code = data.errCode;
// 	var sections = data.sections;
// 	var error_msg = translateErrCode(error_code);

// 	function validSectionsExist(errCode, sections) { return (errCode==1 && sections.length > 0 ); }

// 	$('#err-message').empty();
// 	$('#err-message').append(error_msg);

// 	if( validSectionsExist(error_code, sections) ) {
// 		for(i=0; i<sections.length; i++) { 
// 			var inputSection = new Section(sections[i], dropSectionButtonClick, "Drop" );
// 			$('#user-sections').append( inputSection.renderHTML().show() );
// 		}
// 		return true;
// 	}
//  	return false;
// }

// function handleGetScheduleResponse(data) {
// 	var error_code = data.errCode;
// 	var sections = data.sections;
// 	var error_msg = translateErrCode(error_code);

// 	function validSectionsExist(errCode, sections) { return (errCode ==1 && sections.length > 0 ); }

// 	$('#err-message').empty();
// 	$('#err-message').append(error_msg);

// 	if( validSectionsExist(error_code, sections) ) {
// 		for(i=0; i<sections.length; i++) { 
// 			var inputSection = new Section(sections[i], registerButtonClick, "Register");
// 			$('#all-registrations').append( inputSection.renderHTML().show() );
// 		}
// 		return true;
// 	}
//  	return false;
// }

// function handleRegisterSectionResponse(data) {
// 	var error_code = data.errCode;
// 	var status_msg = translateErrCode(error_code);
// 	$('#err-message').empty();
// 	$('#err-message').append(status_msg);
// 	if(error_code == 1) {alert("Success");}
// 	else {alert('failure');}
// 	return false;
// }
