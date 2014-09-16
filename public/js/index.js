var data = document.getElementsByClassName('data');
var mes = ["JAN", "FEV", "MAR", "ABR", "MAIO", "JUN", "JUL", "AGO", "SET", "OUT", "NOV", "DEZ"];
for (var i = data.length - 1; i >= 0; i--) {
	var dat = data[i].innerHTML;
	console.log(dat.length, dat);
	dat = dat.substring(10, 15);		
	m = dat.substring(0, 2);
	m = parseInt(m)-1;
	dat = dat.substring(3,5) +'' + mes[m];		
	data[i].innerHTML = dat;
};