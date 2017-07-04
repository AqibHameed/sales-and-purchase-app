var URL = 'http://172.20.4.111:4000/';
var CAT_URL = URL + 'categories';
var MES_URL = URL + 'messages';

function loadDate() {

	var m_names = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
	var d = new Date();
	var curr_date = d.getDate();
	var curr_month = d.getMonth();
	$('#date p.center').html(curr_date + 'th ' + m_names[curr_month])

}

function loadCategories() {

	var date = new Date();
	var d = date.getDate();
	var m = date.getMonth() + 1;
	var y = date.getFullYear();
	var dt = '' + y + '-' + (m <= 9 ? '0' + m : m) + '-' + (d <= 9 ? '0' + d : d);
	
	$.ajax({
		type : 'GET',
		url : MES_URL + '?date=' + dt,
		datatype: 'jsonp',
		success : function(data) {
			$.each(data, function(i, item) {
				alert(item.message)

			});
		},
		error : function(e) {
			//called if there is an error
			//console.log(e.message);
		}
	});
	
}
