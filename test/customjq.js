$(document).ready(function() {

var $loading = $('#loadingDiv').hide();
$(document)
  .ajaxStart(function () {
	$loading.show();
  })
  .ajaxStop(function () {
	$loading.hide();
  });

  $.ajax({
		dataType: 'json',
		url: 'content.js',
		data: 'data',
		success: function (data) {
		$.each(data, function(key) {
				var myslug = data[key].slug;
				var myimage = data[key].image;
				var myblurb = data[key].blurb;
				var mycta = data[key].cta;
				$("#epresults").append("<div class='slug'>"+myslug+"</div>");
				$("#epresults").append("<div class='image'><img src='"+myimage+"' alt=''></div>");
				$("#epresults").append("<div class='blurb'>"+myblurb+"</div>");
				$("#epresults").append("<div class='cta'><a href=''>"+mycta+"</a></div><hr>");
			})
		},
		error: function(xhr, desc, err) {
			console.log(xhr);
			console.log("Details: " + desc + "\nError:" + err);
		}
	});
	$("#epresults").show();
});

