var charts = []; // globally available

$(document).ready(function() {
	$.get("/data", function(data) {
		var names = ["Jesse Pollak","Emily Hayes", "Niki Sawhney", "Wes Haas"]
			for (var j = 0; j < 4; j++) {
					var name = names[j];
					var d = data[name];
					var fb = [];
					var tw = [];
					for (var i = 0; i < d.facebook.length; i++) {
						var f = d.facebook[i]
						fb.push(f.posts.length);
					}
					for (var i = 0; i < d.twitter.length; i++) {
						var t = d.twitter[i];
						tw.push(t.tweets.length);
					}
					var chart = new Highcharts.Chart({
				     chart: {
				        renderTo: name.split(" ")[0],
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
					charts.push(chart);
				}
			}, "json");
});