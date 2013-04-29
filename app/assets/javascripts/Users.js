
////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// User Object ////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
var User = function(first, last, email, password, password_confirmation, dob, extra, contacts, residence) {
	this.first = (first === undefined) ? "" : first;
	this.last = (last === undefined) ? "" : last;
	this.email = (email === undefined) ? "" : email;
	this.dob = (dob === undefined) ? "" : dob;
	this.password = (password === undefined) ? "" : password;
	this.password_confirmation = (password_confirmation === undefined) ? "" : password_confirmation;
  this.contacts = contacts===undefined ? new Contacts() : contacts;
  this.residence = residence===undefined ? new Residence() : residence;
	this.extra = (extra === undefined) ? "" : extra;
};

User.collectInput = function(action, user) {
  extractValue(action,user);

  var gender_id = action + "-gender";
  var skill_id = action + "-skill";

  user["gender"] = getRadioValue(gender_id); //handle radios seperate
  user["skill"] = getRadioValue(skill_id); //str->int w/ radix=10

  return user;
}

User.renderHTML = function(action, user, isField) {
    if(typeof user!=null) {
      injectValue(action, user, isField);
      return true;
    }
    return false;
}

  // handle simple input texts 
  // for(var key in this) {
  //   var identifier = "#" + action + "-" + key;
  //   this[key] = $(identifier).val();
  // }
  // var residence = new Residence();
  // var contacts = new Contacts(); //abstact away objects for possible future error checking

  // this.residence = residence.collectInput(action); //use objects functions to grab values
  // this.contacts = contacts.collectInput(action);



////////////////////////////////////////////////////////////////////////////////////
 //////////////////////////////////// Helper functions //////////////////////////////
 ////////////////////////////////////////////////////////////////////////////////////

function injectValue( identifier, obj ,isField) {
  for(var key in obj) {
      var val = obj[key];
      var isRecursable = (typeof val == 'object') || (typeof val == 'array');
      var isFinal = (typeof val == 'string') || (typeof val == 'boolean') || (typeof val == 'number');

      if( isFinal ) {
          var final_id = "#" + identifier + "-" + key;
          if(isField) { $(final_id).val(val);  }
          else        { $(final_id).html(val); }
          continue;
      }
      else if( isRecursable ) {
          var next_identifier = identifier + "-" + key;
          injectValue(next_identifier, val, isField);
      }
      else {
          alert("error occurred");
          return false;
      }
  }
  return true;
}

function extractValue( identifier, obj) {
  for(var key in obj) {
      var val = obj[key];
      var isRecursable = (typeof val == 'object') || (typeof val == 'array');
      var isFinal = (typeof val == 'string') || (typeof val == 'boolean') || (typeof val == 'number');

      if( isFinal ) {
        var final_id = "#" + identifier + "-" + key;
        obj[key] = $(final_id).val();
        continue;
      }
      else if( isRecursable ) {
          var next_identifier = identifier + "-" + key;
          val[key] = extractValue(next_identifier, val);
      }
      else {
          alert("failed " + key + " : " + val);
          return null;
      }
  }
  return;
}
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

function getRadioValue(attribute) {
	var radioId = "input[name=" + attribute + "]:radio:checked";
	return $(radioId).val();
}

function collectInput(action, obj) {
	for(var key in obj) { obj[key] = getFormInput(action, key); }
	return obj;
}

