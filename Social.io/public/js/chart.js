var chart1; // globally available

$(document).ready(function() {
	$.get("/data", function(data) {
		var fb = [];
		var tw = [];
		var dates = [];
		for (var i = 0; i < data.facebook.length; i++) {
			var f = data.facebook[i]
			fb.push(f.posts.length);
		}
		for (var i = 0; i < data.twitter.length; i++) {
			var t = data.twitter[i];
			tw.push(t.tweets.length);
		}
		chart1 = new Highcharts.Chart({
	     chart: {
	        renderTo: 'container',
	        type: 'line'
	     },
	     title: {
	        text: ''
	     },
	     xAxis: {
	        type: 'datetime'
	     },
	     yAxis: {
	        title: {
	           text: 'Status updates'
	        },
					min: 0
	     },
	     series: [{
	        name: 'Facebook',
	        data: fb,
					pointStart: Date.UTC(2012, 2, 16),
					pointInterval: 24*3600*1000 //one day
	     }, {
	        name: 'Twitter',
	        data: tw,
					pointStart: Date.UTC(2012, 2, 16),
					pointInterval: 24*3600*1000 //one day
	     }]
	  });
	}, "json");

});