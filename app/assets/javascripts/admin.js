function show_login_page() {
  $('#main-page').show();
  $('#new-form').hide();
  $('#edit-form').hide();
}

function refresh_after_create() {
    $('#main-page').show();
    $('#new-form').hide();
}

function toggle_new_form() {
  $('#new-form').toggle(); 
}

/* Takes a dictionary to be JSON encoded, calls the success
   function with the diction decoded from the JSON response.*/
function post_json_request(page, dict, success) {
  $.ajax({
    type: 'POST',
    url: page,
    data: JSON.stringify(dict),
    contentType: "application/json",
    dataType: "json",
    success: success
  });
}

/* read this
*/
function get_json_request(page, dict, success) {
  $.ajax({
    type: 'GET',
    url: page,
    data: JSON.stringify(dict),
    contentType: "application/json",
    dataType: "json",
    success: success
  });
}

function handle_add_response(data) {
  if (data.errCode == 1) {
    $('#new-form').hide();
    $('#edit-form').hide();
    $('#section-table').fadeOut('slow', function() {
        post_json_request("/Sections/getAllSections", {}, function(data) {loadingSections(data)});
        $('#section-table').fadeIn('fast');
    })
    //post_json_request("/Registrations/getSchedule", {}, function(data) {loadingBody(data)});
    $('form').clearForm();
  } else {
    alert(translateErrCode(data.errCode));
  }
}

function handle_edit_response(data) {
    if (data.errCode == 1) {
        alert(data.sections[0].teacher);
    $('#edit-form').loadJSON(data.sections[0]);
    //post_json_request("/Registrations/getSchedule", {}, function(data) {loadingBody(data)});
    $('#edit-form').toggle();
  } else {
    alert(translateErrCode(data.errCode));
  }
}

function init_data() {
    post_json_request("/Sections/getAllSections", {}, function(data) {loadingSections(data)})
}

function loadingSections(data){
    //alert(data.errCode)
    if (data.errCode == 250) {
        document.getElementById('section-table').innerHTML='No records found!';
    } else {
        var json = data.sections
        if(json.length > 0){
            createSectionTable(json);
        } else {
            document.getElementById('section-table').innerHTML='No records found!';
        }
    }
}

function loadingUsers(data){
    var json = data.sections
    if(json.length > 0){
        createSectionTable(json);
    } else {
        document.getElementById('user-table').innerHTML='No records found!';
    }
}

function createTableRowContent(rowObject, data, cellType){
    var rowContent = document.createElement(cellType);
    var cell = document.createTextNode(data);
    rowContent.appendChild(cell);
    rowObject.appendChild(rowContent);
}

function createTableData(rowObject, data){
    createTableRowContent(rowObject, data, 'td');
}

function createTableHeader(rowObject, data){
    createTableRowContent(rowObject, data, 'th');
}

function createSectionTable(jsonString){
    
    var table = document.createElement('table');
    //table.border = "1";
    //set table style
   
    table.style.fontFamily = "verdana", "arial", "sans-serif";
    table.style.fontSize = "11px";
    table.style.textAlign = "center";
    table.style.color = "#333333";
    // table.style.borderWidth = "1px";
    // table.style.borderColor = "#222222";
    table.style.cellSpacing = "0";

    var thead = document.createElement('thead');
    thead.style.background = "#b5cfd2";
    // thead.style.borderWidth = "1px";
    thead.style.padding = "8px"
    // thead.style.borderStyle = "solid";
    // thead.style.borderColor = "#222222";
    thead.style.textAlign = "center";

    table.appendChild(thead);

    var row = document.createElement('tr');
        row.style.background = "#dcddc0";
        // row.style.borderWidth = "1px";
        row.style.padding = "8px";
        // row.style.borderStyle = "solid";
        // row.style.borderColor = "#222222";
        row.style.textAlign = "center";

    createTableHeader(thead, 'Id');
    createTableHeader(thead, 'Name');
    createTableHeader(thead, 'Start Date');
    createTableHeader(thead, 'End Date');
    createTableHeader(thead, 'Day');
    createTableHeader(thead, 'Start Time');
    createTableHeader(thead, 'End Time');
    createTableHeader(thead, 'Teacher');
    createTableHeader(thead, 'Current Enrollment');
    createTableHeader(thead, 'Max Enrollment');
    createTableHeader(thead, 'Current Waitlist');
    createTableHeader(thead, 'Max Waitlist');
    createTableHeader(thead, 'Section Type');
    createTableHeader(thead, 'Lesson Type');
    createTableHeader(thead, 'Description');
    createTableHeader(thead, 'Actions');
    
    thead.appendChild(row);
    
    var tbody = document.createElement('tbody');
    table.appendChild(tbody);
    
    for(i=0; i<jsonString.length; i++){
        var row = document.createElement('tr');
        row.style.background = "#dcddc0";
        // row.style.borderWidth = "1px";
        row.style.padding = "8px";
        // row.style.borderStyle = "solid";
        // row.style.borderColor = "#222222";
        row.style.textAlign = "center";

        createTableData(row, jsonString[i].id);
        createTableData(row, jsonString[i].name);
        createTableData(row, parseDate(jsonString[i].start_date));
        createTableData(row, parseDate(jsonString[i].end_date));
        createTableData(row, jsonString[i].day);
        createTableData(row, parseTime(jsonString[i].start_time));
        createTableData(row, parseTime(jsonString[i].end_time));
        createTableData(row, jsonString[i].teacher);
        createTableData(row, jsonString[i].enroll_cur);
        createTableData(row, jsonString[i].enroll_max);
        createTableData(row, jsonString[i].waitlist_cur);
        createTableData(row, jsonString[i].waitlist_max);
        createTableData(row, jsonString[i].section_type);
        createTableData(row, jsonString[i].lesson_type);
        createTableData(row, jsonString[i].description);

        var bt = document.createElement('input');
        bt.type = 'button';
        bt.name = 'delete-section';
        bt.id = 'delete-section';
        bt.value = 'Delete';
        bt.style.width = '60px';
        bt.onclick = function() {post_json_request("/Sections/delete", { id: $(this).closest('tr').children('td:first').text() }, function(data) { return handle_add_response(data); });};
        //bt.onclick = function() {alert($(this).closest('tr').children('td:first').text())};
        
        var bte = document.createElement('input');
        bte.type = 'button';
        bte.name = 'edit-section';
        bte.id = 'edit-section';
        bte.value = 'Edit';
        bte.style.width = '50px';
        bte.onclick = function() {
            post_json_request("/Sections/getSectionByID", { id: $(this).closest('tr').children('td:first').text() }, function(data) { return handle_edit_response(data); });
        };

        row.appendChild(bt);
        row.appendChild(bte);

        tbody.appendChild(row);   
    }

    document.getElementById('section-table').innerHTML = '';
    document.getElementById('section-table').appendChild(table);
}

function createUserTable(jsonString){
    
    var table = document.createElement('table');
    //table.border = "1";
    //set table style
   
    table.style.fontFamily = "verdana", "arial", "sans-serif";
    table.style.fontSize = "11px";
    table.style.textAlign = "center";
    table.style.color = "#333333";
    // table.style.borderWidth = "1px";
    // table.style.borderColor = "#222222";
    table.style.cellSpacing = "0";

    var thead = document.createElement('thead');
    thead.style.background = "#b5cfd2";
    // thead.style.borderWidth = "1px";
    thead.style.padding = "8px"
    // thead.style.borderStyle = "solid";
    // thead.style.borderColor = "#222222";
    thead.style.textAlign = "center";

    table.appendChild(thead);

    var row = document.createElement('tr');
        row.style.background = "#dcddc0";
        // row.style.borderWidth = "1px";
        row.style.padding = "8px";
        // row.style.borderStyle = "solid";
        // row.style.borderColor = "#222222";
        row.style.textAlign = "center";

    createTableHeader(thead, 'Id');
    createTableHeader(thead, 'First Name');
    createTableHeader(thead, 'Last Name');
    createTableHeader(thead, 'Email');
    createTableHeader(thead, 'DOB');
    createTableHeader(thead, 'Zip Code');
    createTableHeader(thead, 'Password');
    createTableHeader(thead, 'Admin');
    
    thead.appendChild(row);
    
    var tbody = document.createElement('tbody');
    table.appendChild(tbody);
    
    for(i=0; i<jsonString.length; i++){
        var row = document.createElement('tr');
        row.style.background = "#dcddc0";
        // row.style.borderWidth = "1px";
        row.style.padding = "8px";
        // row.style.borderStyle = "solid";
        // row.style.borderColor = "#222222";
        row.style.textAlign = "center";

        createTableData(row, jsonString[i].id)
        createTableData(row, jsonString[i].first);
        createTableData(row, jsonString[i].last);
        createTableData(row, jsonString[i].email);
        createTableData(row, jsonString[i].dob);
        createTableData(row, jsonString[i].zip);
        createTableData(row, jsonString[i].password);
        createTableData(row, jsonString[i].admin);

        var bt = document.createElement('input');
        bt.type = 'button';
        bt.name = 'delete-section';
        bt.id = 'delete-section';
        bt.value = 'Delete';
        bt.style.width = '60px';
        bt.onclick = function() {post_json_request("/Users/delete", { name: $(this).closest('tr').children('td:first').text() }, function(data) { return handle_add_response(data); });};
        //bt.onclick = function() {alert($(this).closest('tr').children('td:first').text())};

        row.appendChild(bt);

        tbody.appendChild(row);   
    }

    document.getElementById('user-table').innerHTML = '';
    document.getElementById('user-table').appendChild(table);
}

function parseTime(timeIn) {
    time = timeIn.split('T')[1].split('Z')[0].split(':')
    var timeEnd = 'AM';
    var hour = 0;
    var min = 0;
    if (time[0] > 12 && time[0] > 22) {
        timeEnd = 'PM';
        hour = time[0] - 12;
    } else if (time[0] > 12) {
        timeEnd = 'PM';
        hour = '0' + time[0] - 12;
    } else if (time[0] == '00') {
        hour = 12;
    } else {
        hour = time[0] % 12;
    }
    min = time[1];

    return (hour + ':' + min + timeEnd);  
}

function parseDate(dateIn) {
    date = dateIn.split('-');
    return (date[1] + '-' + date[2] + '-' + date[0]);
}