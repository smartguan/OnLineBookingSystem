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
    $('#user-table').fadeOut('slow', function() {
        post_json_request("/Admin/allUsers", {}, function(data) {loadingUsers(data)});
        $('#user-table').fadeIn('fast');
    })
  } else {
    alert(translateErrCode(data.errCode));
  }
}

function handle_edit_response(data) {
    if (data.errCode == 1) {
        //alert(data.sections[0].teacher);
    $('#new-form3').loadJSON(data.sections[0]);
    //post_json_request("/Registrations/getSchedule", {}, function(data) {loadingBody(data)});
     $('#new-form3').toggle();
  } else {
    alert(translateErrCode(data.errCode));
  }
}

function init_user_data() {
    post_json_request("/Admin/allUsers", {}, function(data) {loadingUsers(data)})
    //post_json_request("/Sections/getAllSections", {}, function(data) {loadingSections(data)})
}

function loadingUsers(data){
    var json = data.users
    if(json.length > 0){
        createUserTable(json);
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
    thead.style.padding = "20px"
    // thead.style.borderStyle = "solid";
    // thead.style.borderColor = "#222222";
    thead.style.textAlign = "center";

    table.appendChild(thead);

    var row = document.createElement('tr');
        row.style.background = "#dcddc0";
        // row.style.borderWidth = "1px";
        row.style.padding = "20px";
        // row.style.borderStyle = "solid";
        // row.style.borderColor = "#222222";
        row.style.textAlign = "center";

    createTableHeader(thead, 'Id');
    createTableHeader(thead, 'First Name');
    createTableHeader(thead, 'Last Name');
    createTableHeader(thead, 'Email');
    createTableHeader(thead, 'DOB');
    createTableHeader(thead, 'Street Address');
    createTableHeader(thead, 'City');
    createTableHeader(thead, 'Zip Code');
    createTableHeader(thead, 'Gender');
    createTableHeader(thead, 'Skill');
    createTableHeader(thead, 'Created')
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

        createTableData(row, jsonString[i].id)
        createTableData(row, jsonString[i].first);
        createTableData(row, jsonString[i].last);
        createTableData(row, jsonString[i].email);
        createTableData(row, jsonString[i].dob);
        createTableData(row, jsonString[i].address);
        createTableData(row, jsonString[i].city);
        createTableData(row, jsonString[i].zip);
        createTableData(row, jsonString[i].gender);
        createTableData(row, jsonString[i].skill);
        createTableData(row, jsonString[i].created_at);

        var bt = document.createElement('input');
        bt.type = 'button';
        bt.name = 'delete-section';
        bt.id = 'delete-section';
        bt.value = 'Delete';
        bt.style.width = '60px';
        bt.onclick = function() {post_json_request("/Admin/delete", { id: $(this).closest('tr').children('td:first').text() }, function(data) { return handle_add_response(data); });};
        //bt.onclick = function() {alert($(this).closest('tr').children('td:first').text())};

        row.appendChild(bt);

        tbody.appendChild(row);   
    }

    document.getElementById('user-table').innerHTML = '';
    document.getElementById('user-table').appendChild(table);
}
