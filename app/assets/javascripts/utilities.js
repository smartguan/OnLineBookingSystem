function parseTime_reservation(timeIn) {
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

function parseDate_reservation(dateIn) {
    date = dateIn.split('-');
    return (date[1] + '-' + date[2] + '-' + date[0]);
}

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