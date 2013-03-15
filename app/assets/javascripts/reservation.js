function show_login_page_reservation() {
  $('#main-page').show();
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

function init_data() {
    post_json_request("/Registrations/getSchedule", {}, function(data) {loadingBody(data)})
}

function loadingBody(data){
    if (data.errCode == 300) {
        document.getElementById('mytable_reservation').innerHTML='No records found!';
    } else {
        var json = data.sections
        if(json.length > 0){
            displayData(json);
        } else {
            document.getElementById('mytable_reservation').innerHTML='No records found!';
        }
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

function displayData(jsonString){
    
    var table = document.createElement('table');
    //table.border = "1";
    //set table style
   
    table.style.fontFamily = "verdana", "arial", "sans-serif";
    table.style.fontSize = "11px";
    table.style.textAlign = "center";
    table.style.color = "#333333";
    table.style.borderWidth = "1px";
    table.style.borderColor = "#222222";
    table.style.cellSpacing = "0";

    var thead = document.createElement('thead');
    thead.style.background = "#b5cfd2";
    thead.style.borderWidth = "1px";
    thead.style.padding = "8px"
    thead.style.borderStyle = "solid";
    thead.style.borderColor = "#222222";
    thead.style.textAlign = "center";

    table.appendChild(thead);

    var row = document.createElement('tr');
        row.style.background = "#dcddc0";
        row.style.borderWidth = "1px";
        row.style.padding = "8px";
        row.style.borderStyle = "solid";
        row.style.borderColor = "#222222";
        row.style.textAlign = "center";

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
    createTableHeader(thead, 'Description');
    createTableHeader(thead, 'Actions');
    
    thead.appendChild(row);
    
    var tbody = document.createElement('tbody');
    table.appendChild(tbody);
    
    for(i=0; i<jsonString.length; i++){
        var row = document.createElement('tr');
        row.style.background = "#dcddc0";
        row.style.borderWidth = "1px";
        row.style.padding = "8px";
        row.style.borderStyle = "solid";
        row.style.borderColor = "#222222";
        row.style.textAlign = "center";

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
        createTableData(row, jsonString[i].description);

        var bt = document.createElement('input');
        bt.type = 'button';
        bt.name = 'reserve-section';
        bt.id = 'reserve-section';
        bt.value = 'Reserve';
        bt.style.width = '75px';
        //bt.onclick = function() {post_json_request("", { name: $(this).closest('tr').children('td:first').text() }, function(data) { return handle_add_response(data); });};
        //bt.onclick = function() {alert($(this).closest('tr').children('td:first').text())};
        bt.onclick = function() {alert('Coming soon!')};
        row.appendChild(bt);

        tbody.appendChild(row);
    }

    document.getElementById('mytable_reservation').innerHTML = '';
    document.getElementById('mytable_reservation').appendChild(table);
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
