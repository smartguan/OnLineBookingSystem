var Section = function(sectionJSON, clickFunction, buttonTitle) {
	this.title = sectionJSON.name;
	this.instructor = sectionJSON.teacher;
	this.description = sectionJSON.description;
	this.date_start = parseDate_reservation(sectionJSON.start_date);
	this.date_end = parseDate_reservation(sectionJSON.end_date);
	this.date_range = new Range(this.date_start, this.date_end);
	this.time_start = parseTime_reservation(sectionJSON.start_time);
	this.time_end = parseTime_reservation(sectionJSON.end_time);
	this.time_range = new Range(this.time_start, this.time_end);	
	this.waitlist_frac = new Frac(sectionJSON.waitlist_cur, sectionJSON.waitlist_max);
	this.enroll_frac = new Frac(sectionJSON.enroll_cur, sectionJSON.enroll_max);

	this.renderHTML = function() {
		var $section_clone = $('#section-template').clone();
		$section_clone.removeAttr('id').addClass('section');

		$section_clone.find('.instructor').append(this.instructor);
		$section_clone.find('.description').append(this.description);
		$section_clone.find('.time').append(this.time_range.string);
		$section_clone.find('.date').append(this.date_range.string);
		$section_clone.find('.waitlisted').append(this.waitlist_frac.string);
		$section_clone.find('.enrolled').append(this.enroll_frac.string);
		
		$section_clone.find('a.title').append(this.title).click(function() {$(this).siblings().slideToggle();});

		$section_clone.find('button').append(buttonTitle);

		$section_clone.find('button').on("click", {title:this.title}, function(event) { clickFunction(event.data.title) });		
		return $section_clone;
	}
}

var Range = function(start, end) 
{
	this.start = start;
	this.end = end;
	this.string = (this.start + " - " + this.end);
}

var Frac = function(numerator, demoninator) 
{
	this.numerator = numerator;
	this.demoninator = demoninator;
	this.string = (this.numerator + " / " + this.demoninator);
}

var CustomButton = function(clickFunction, size, text) {
	var buttonClass = "btn btn-"+ size + " btn-primary";
	var tempButton = $('<button type="button"></button>').addClass(buttonClass);
	tempButton.append(text);
	tempButton.on("click", {title:this.title}, function(event) { clickFunction(event.data.title) });	
}