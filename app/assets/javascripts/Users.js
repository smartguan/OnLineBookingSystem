
////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// User Object ////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
var User = function(first, last, email, password, password_confirmation, dob, additional_info) {
	this.first = (first === undefined) ? "" : first;
	this.last = (last === undefined) ? "" : last;
	this.email = (email === undefined) ? "" : email;
	this.dob = (dob === undefined) ? "" : dob;
	this.password = (password === undefined) ? "" : password;
	this.password_confirmation = (password_confirmation === undefined) ? "" : password_confirmation;
	this.additional_info = (additional_info === undefined) ? "" : additional_info;
};

User.prototype.collectInput = function(action) {
  // handle simple input texts 
  for(var key in this) {
    var identifier = "#" + action + "-" + key;
    this[key] = $(identifier).val();
  }
  var residence = new Residence();
  var contacts = new Contacts(); //abstact away objects for possible future error checking

  this.residence = residence.collectInput(action); //use objects functions to grab values
  this.contacts = contacts.collectInput(action);

  // this.gender = parseInt(getRadioValue("gender"),10); //handle radios seperate
  // this.skill = parseInt(getRadioValue("skill"),10); //str->int w/ radix=10
  var gender_id = action + "-gender";
  var skill_id = action + "-skill";
  // this.gender = getRadioValue("create-gender"); //handle radios seperate
  // this.skill = getRadioValue("create-skill"); //str->int w/ radix=10
  this.gender = getRadioValue(gender_id); //handle radios seperate
  this.skill = getRadioValue(skill_id); //str->int w/ radix=10

  return this;
}


User.renderHTML = function(action, user) {
    if(typeof user!=null) {
      injectValue(action, user);
      return true;
    }
    return false;
}

////////////////////////////////////////////////////////////////////////////////////
 //////////////////////////////////// Helper functions //////////////////////////////
 ////////////////////////////////////////////////////////////////////////////////////
function translateSkillLevel(skill_num) {
    var msg = ""
    switch(skill_num) {
        case 0: return "Beginner";
        case 1: return "Beginner Strokes";
        case 2: return "Intermediate";
        case 3: return "Advanced";
    }
    return "ERROR";
}

function getFormInput(action, key) {
  var identifier = "#" + action + "-" + key;
  return $(identifier).val();
}

function injectValue( identifier, obj ) {
  for(var key in obj) {
      var val = obj[key];
      var isRecursable = (typeof val == 'object') || (typeof val == 'array');
      var isFinal = (typeof val == 'string') || (typeof val == 'boolean') || (typeof val == 'number');

      if( isFinal ) {
          var final_id = "#" + identifier + "-" + key;
          $(final_id).html(val);
      }
      else if( isRecursable ) {
          var next_identifier = identifier + "-" + key;
          injectValue(next_identifier, val);
      }
      else {
          alert("error occurred");
          return false;
      }
  }
  return true;
}


function getRadioValue(attribute) {
	var radioId = "input[name=" + attribute + "]:radio:checked";
	return $(radioId).val();
}

function collectInput(action, obj) {
	for(var key in obj) { obj[key] = getFormInput(action, key); }
	return obj;
}

function getFormInput(action, key) {
	var identifier = "#" + action + "-" + key;
	return $(identifier).val();
}
