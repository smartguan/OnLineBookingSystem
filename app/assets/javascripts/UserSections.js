//
/////////////////////////////////////////////////////
////////////////////Section /////////////////////////
/////////////////////////////////////////////////////
var Section = function(header, rest_of_attr) {
  this.header = header;
  for (var key in rest_of_attr) {
    this[key] = rest_of_attr[key];
  }
}

Section.renderHTML = function(section, buttonTitle, clickFunction) {
    var $section_clone = $('#section-template').clone().removeAttr('id');
    // handle bootstrap constraints
    var section_id = pop(section, "id");
    // alert(section_id);
    $section_clone.find('.section-header').attr('href',("#section-"+ section_id) );
    $section_clone.find('.section-header').attr('data-target',("#section-"+ section_id) );
    $section_clone.find('.section-body').attr('id',"section-"+  section_id);
    $section_clone = translateStatus($section_clone, pop(section,"waitlist_place"), pop(section,"waitlist_max"));


    for (var key in section) {
      var val = section[key];
      if(isValid(val)) {  
        var htmltag = ".section-" + key;
        $section_clone.find(htmltag).append(val.toString());
      }
    }

    $section_clone.find('.section-eventButton').append(buttonTitle).on("click", { section_id: section_id }, clickFunction);
    
    return $section_clone;
}

/////////////////////////////////////////////////////
////////////////////SectionS /////////////////////////
/////////////////////////////////////////////////////
var Sections = function(sectionsJSON) {
  this.all = sectionsJSON;
  for(i=0; i<sectionsJSON.length; i++) {
    this.all.push(sectionsJSON[i]);
  }
}

Sections.renderHTML = function(sections) {
    var enrolledID = "#show-enrolled-sections";
    $(enrolledID).empty().show();
  
    for(i=0; i<sections.length; i++) { 
        var section = sections[i];

        // var start_date = parseDate(pop(section, "start_date"));
        // var end_date = parseDate(pop(section, "end_date"));
        // var date_range = new Range( start_date, end_date );

        var start_time = parseTime(pop(section,"start_time"));
        var end_time = parseTime(pop(section,"end_time"));
        var time_range = new Range( start_time, end_time );


        var dow = translateDOW( pop(section, "section_type"), pop(section, "day") );
        var header_msg = createHeaderMessage(pop(section,"name"), dow, time_range);
        section = {
            id: section.id,
            teacher : section.teacher,
            start_date : parseDate(section.start_date),
            end_date : parseDate(section.end_date),
            description : section.description,
            lesson_type : section.lesson_type,
            waitlist_place : section.waitlist_place,
            waitlist_max : section.waitlist_max
        }
        
        var temp = new Section(header_msg, section);

        var temphtml = Section.renderHTML(temp,"Drop", showConfirmation).show();
        $(enrolledID).append(temphtml);
      
    }
    return true;
}


//////////////////////////// Display Functions //////////////////////////////
function translateDOW(section_type, day) {
    var  dow_out = "ERROR";

    if (section_type=="A") { dow_out = "Mon, Tues, Wed, Thurs"; }
    else if (section_type=="B") { dow_out = "Sat, Sun"; }
    else { dow_out = day; }

    return dow_out;
}

function translateStatus(clone, waitlist_place, waitlist_max) {

  if(waitlist_place==0) {
    clone.find(".section-status").append("Enrolled").parent().addClass("status-enrolled");
  }
  else {
    var frac = new Frac(waitlist_place, waitlist_max);
    var text = "Waitlisted : " + frac.toString();
    clone.find(".section-status").append(text).parent().addClass("status-waitlisted");
    //.addClass("status-waitlisted");
  }
  return clone;
}

function createHeaderMessage(title, dow, time_frac) {
  return title + " ---- " + dow + " ---- " + time_frac.toString();
}

function getRandomNum(range) {
  return Math.floor(Math.random()*range);
}

function mock_missing_fields(section) {
  var group_enum = ["private", "group", "precomp"];
  var type_enum =  ["A", "B", "C"];
  section.waitlist_place = getRandomNum(2);
  section.section_type = group_enum[getRandomNum(group_enum.length)];
  section.lesson_type = type_enum[getRandomNum(type_enum.length)];
}

function mock_waitlist_pos(section) {
  section.waitlist_place = getRandomNum(section.waitlist_max);
}

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
// });
// function getRandomNum(range) {
//   return Math.floor(Math.random()*range);
// }
// function mock_missing_fields(section) {
//   section.waitlist_pos = getRandomNum(10);
//   section.section_type = getRandomNum(10);
//   section.lesson_type = "A";
// }


// function handleViewSectionsResponse(data) {
//   var error_code = data.errCode;
//   var sections = data.sections;
//   var error_msg = translateErrCode(error_code);

//   function validSectionsExist(errCode, sections) { return (errCode==1 && sections.length > 0 ); }

//   $('#err-message').empty();
//   $('#err-message').append(error_msg);
//   //alert(sections.length);
//   if( validSectionsExist(error_code, sections) ) {
//     Sections.renderHTML(sections);
//   }
//   return false;
// }
// function handleRegisterSectionResponse(data) {
//  var error_code = data.errCode;
//  var status_msg = translateErrCode(error_code);
//  $('#err-message').empty();
//  $('#err-message').append(status_msg);
  
//  if(error_code == 1) {
//    alert("Success");
//  }
//  else { 
//    alert('failure');
//  }
//  return false;
// }

// var Sections = function(sectionsJSON) {
//   this.all = sectionsJSON;
//   for(i=0; i<sectionsJSON.length; i++) {
//     this.all.push(sectionsJSON[i]);
//   }
// }

// Sections.renderHTML = function(sections) {
//     var enrolledSectionsId = "#show-enrolled-sections";
//     for(i=0; i<sections.length; i++) { 
//       var section = sections[i];
//       // var section.start_date = (section.start_date===null || section.start_date===undefined) ? "" : section.start_date;
//       // var section.end_date = (section.start_date===null || section.start_date===undefined) ? "" : section.start_date;
//       // var date_range = new Range( parseDate_reservation(start_date), parseDate_reservation(end_date) );
//       // var time_range = new Range( parseTime_reservation(start_time), parseTime_reservation(end_time) );

//       var start_date = section.start_date === null ? "" : parseDate_reservation(section.start_date);
//       var end_date = section.end_date === null ? "" : parseDate_reservation(section.end_date);
//       var start_time = section.start_time === null ? "" : parseDate_reservation(section.start_time);
//       var end_time = section.end_time === null ? "" : parseDate_reservation(section.end_time);

//       var date_range = new Range( start_date, end_date );
//       var time_range = new Range( start_time, end_time );
//       var waitlist_frac = new Frac(section.waitlist_cur, section.waitlist_max);
//       var enroll_frac = new Frac(section.enroll_cur, section.enroll_max);
//       // alert(section.teacher);
//       var section_attr = { 
//         id : section.id,
//         name : section.name,
//         teacher : section.teacher,
//         dates : date_range,
//         time : time_range,
//         waitlisted : waitlist_frac,
//         enrolled : enroll_frac
//       };
//       mock_missing_fields(section_attr);
//       // section["dow"] = translateDOW("A");

//       var temp = new Section(section_attr);    
//       // alert(temp);
//       var temphtml = Section.renderHTML(temp,"Drop", dropSectionButtonClick).show() ;
//       $(enrolledSectionsId).append(temphtml);
//     }
//     return true;
// }


//Button definition
// var Button = function(title, size) {
//   this.title = title===undefined ? "" : title;
//   this.size = size===undefined ? "large" : size;  
//   this.getHTML = function() {
//     return "<button class=\"btn btn-" + this.size +  "btn-primary type=\"button\">" + this.title + "</button>";
//   }
// }
// function dropSectionButtonClick(event) {
//   return  post_json_request("/Registrations/drop", { section_id: event.data.section_id  }, handleRegisterSectionResponse );
// }

// function translateDOW(section_type) {
//  var dow_enum = ["Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun"];
//  var  dow_out = "";
//  var boolArray = [];
//  if (section_type=="A") {
//     boolArray = [true, true, true, true, true, false, false];
//  }
//  else if (section_type=="B") {
//     boolArray = [false, false, false, false, false, true, true];
//  }
//  for(i=0; i<boolArray.length; i++) {
//   dow_out += boolArray[i] ? dow_enum[i] + " " : "";
//   // alert(dow_out);
//  }
//  return dow_out;
// }

// var Section = function( attributes, eventButton) {
//   for (var key in attributes) {
//     var val = attributes[key];
//     this[key] = (val===null || val===undefined) ? "" : val;
//   }
//   this.eventButton = (button===undefined) ? "" : eventButton;
// }
// var Section = function( attributes) {
//   for (var key in attributes) {
//     this[key] = attributes[key];
//   }
// }

// Section.renderHTML = function(section, buttonTitle, clickFunction) {
//     var $section_clone = $('#section-template').clone().removeAttr('id');
//     // $section_clone.find('.section-dow').prepend(translateDOW("A"));

//     for (var key in section) {
//       var val = section[key];
//       // alert(val);
//       var htmltag = ".section-" + key;
//       $section_clone.find(htmltag).append(val.toString());
//     }

//     // handle bootstrap constraints
//     $section_clone.find('.section-name').attr('href',("#section-"+section.id) );
//     $section_clone.find('.section-body').attr('id',"section-"+ section.id);

//     $section_clone.find('button').append(buttonTitle).on("click", { section_id: section.id }, clickFunction);
    
//     return $section_clone;
// }

// var Range = function(start, end) {
//   this.start = start;
//   this.end = end;
// }

// Range.prototype.toString = function() {
//   return this.start + " -- " + this.end; 
// }

// var Frac = function(numerator, demoninator) {
//   this.numerator = numerator;
//   this.demoninator = demoninator;
// }
// Frac.prototype.toString = function() {
//   return this.numerator + "/" + this.demoninator;
// }



// $(document).ready( function() {
//    init_view_user_sections();
// });






// function showConfirmation(event) {
//   $("#confirm-modal").find(".btn.btn-danger").on("click", { section_id: event.data.section_id }, dropSectionButtonClick);
//   $("#confirm-modal").modal("show");
//   return true;
// }


// Sections.renderHTML = function(sections) {
//     var enrolledSectionsId = "#show-enrolled-sections";
//     // alert(sections.length);
//     for(i=0; i<sections.length; i++) { 
//       alert(i);
//       var section = sections[i];
      
//       // var section.start_date = (section.start_date===null || section.start_date===undefined) ? "" : section.start_date;
//       // var section.end_date = (section.start_date===null || section.start_date===undefined) ? "" : section.start_date;
//       // var date_range = new Range( parseDate_reservation(start_date), parseDate_reservation(end_date) );
//       // var time_range = new Range( parseTime_reservation(start_time), parseTime_reservation(end_time) );

//       var start_date = section.start_date === null ? "" : parseDate(section.start_date);
//       var end_date = section.end_date === null ? "" : parseDate(section.end_date);
//       // var start_time = section.start_time === null ? "" : parseDatesection.start_time);
//       // var end_time = section.end_time === null ? "" : parseDatesection.end_time);
//       var start_time = section.start_time === null ? "" : parseTime(section.start_time);
//       var end_time = section.end_time === null ? "" : parseTime(section.end_time);

//       var date_range = new Range( start_date, end_date );
//       var time_range = new Range( start_time, end_time );
//       var waitlist_frac = new Frac(section.waitlist_cur, section.waitlist_max);
//       var enroll_frac = new Frac(section.enroll_cur, section.enroll_max);
//       // alert(section.teacher);
//       var section_attr = { 
//         id : section.id,
//         name : section.name,
//         teacher : section.teacher,
//         dates : date_range,
//         time : time_range,
//         waitlisted : waitlist_frac,
//         enrolled : enroll_frac,
//         description : section.description,
//         dow: translateDOW(section.section_type)
//       };
//       mock_missing_fields(section_attr);
//       // section["dow"] = translateDOW("A");

//       var temp = new Section(section_attr);    
//       // alert(temp);
//       var temphtml = Section.renderHTML(temp,"Drop", showConfirmation).show() ;
//       $(enrolledSectionsId).append(temphtml);
//     }
//     return true;
// }


//Button definition
// var Button = function(title, size) {
//   this.title = title===undefined ? "" : title;
//   this.size = size===undefined ? "large" : size;  
//   this.getHTML = function() {
//     return "<button class=\"btn btn-" + this.size +  "btn-primary type=\"button\">" + this.title + "</button>";
//   }
// }

// var Section = function(attributes) {
//   for (var key in attributes) {
//     this[key] = attributes[key];
//   }
// }

// Section.renderHTML = function(section, buttonTitle, clickFunction) {
//     var $section_clone = $('#section-template').clone().removeAttr('id');

//     for (var key in section) {
//       var val = section[key];
//       var htmltag = ".section-" + key;
//       $section_clone.find(htmltag).append(val.toString());
//     }

//     // handle bootstrap constraints
//     $section_clone.find('.section-name').attr('href',("#section-"+section.id) );
//     $section_clone.find('.section-body').attr('id',"section-"+ section.id);

//     $section_clone = translateStatus($section_clone, section.waitlist_place, section.waitlisted.demoninator);

//     $section_clone.find('button').append(buttonTitle).on("click", { section_id: section.id }, clickFunction);
    
//     return $section_clone;
// }

