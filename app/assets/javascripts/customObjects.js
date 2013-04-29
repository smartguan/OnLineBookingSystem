///////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// Residence Object //////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
var Residence = function(address, city, zip) {
	this.address = (address === undefined) ? "" : address;
	this.city = (city === undefined) ? "" : city;
	this.zip = (zip === undefined) ? "" : zip;
};

// Residence.prototype.collectInput = function(action) {
// 	for(var key in this) { 
// 		var identifier = "#" + action + "-residence-" + key;
// 		this[key] = $(identifier).val();
// 	}
// 	return this;
// }
///////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// Contacts Objects //////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
var Contacts = function(first, second) {
	this.first = (first === undefined) ? new Contact() : first;
	this.second = (second === undefined) ? new Contact() : second;
};

// Contacts.prototype.collectInput = function(action) {
// 	// for(var key in this) {
// 	// 	var tempContact = new Contact();
// 	// 	var identifier =  "#contacts-" + action + "-" + key + "-"; //create-second-contact-secondary
// 	// 	this[key] = tempContact.collectInput(identifier); //use contacts jquery to retrieve specific id's
// 	// }

// 	var contact_one = new Contact();
// 	var contact_two = new Contact();
// 	this["first"] = contact_one.collectInput("#contacts-first");
// 	this["second"] = contact_two.collectInput("#contacts-second");
// 	return this;
// }




//////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// Contact Objects //////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
var Contact = function(name, primary, secondary) {
	this.name = (name === undefined) ? "" : name;
	this.primary = (primary === undefined) ? "" : primary;
	this.secondary = (secondary === undefined) ? "" : secondary;
};
// Contact.prototype.collectInput = function(first_or_second) {
// 	for(var key in this) { 
// 		var identifier =  first_or_second + "-" + key;
// 		this[key] = $(identifier).val();
// 	}
// 	return this;
// }


//////////////////////////// Helper Objects //////////////////////////////
var Range = function(start, end) {
  this.start = start;
  this.end = end;
}

Range.prototype.toString = function() {
  return this.start + " - " + this.end; 
}

var Frac = function(numerator, demoninator) {
  this.numerator = numerator;
  this.demoninator = demoninator;
}
Frac.prototype.toString = function() {
  return this.numerator + "/" + this.demoninator;
}


