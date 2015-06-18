$(document).ready(function() {
/*
Jeff Epstein 
This is test code to display events in a calendar, and then take a user selection and run a second query to get the event details. Due to the anticipated volume of events, it is more efficient to not store all the details for all events.


*/
		var parentBody = window.parent.document.body; //The ops display is actually nested inside the app window
		var $phase = "";
		var $eventIdToGet = "";
		var $loading = $('#loadingDiv', parentBody).hide();		//loading spinner
		$(document)
		  .ajaxStart(function () {
			$loading.show();
		  })
		  .ajaxStop(function () {
			$loading.hide();
		  });

		
		$.fn.RunAjax = function(phase, eventIdToGet) { 
		console.log("RunAjax fired");
		console.log("phase1: " + $phase);
		if ($phase == ""){
			$phase = 'showTable';
		}
		console.log("phase2: " + $phase);
				$.ajax({							
				type: 	'POST',
				dataType: 'json', 
				response:	"",
				data: { phase: $phase, eventIdToGet: $eventIdToGet }, 
				url:	XXXXXXXX, //employer info censored
				success:	function(response) {	
						if ($phase == 'showTable') {
							var row = -1;
							$.each(response, function(i, item) {
								
								if (row == -1){				//init for alternating rows
									row = 0;
								}
								
								$LnkTitle = "<a class='linkk' id='" + item.eventID + "' href='javascript: void(0);'>" + item.title + "</a>";
										
													
								$('<tr>').append(
									$('<td>').html($LnkTitle),
									$('<td>').text(item.start)
								).appendTo('#eventstable tbody').addClass('d'+ row);
								
								if (row == 0) {				//for alternating rows
									row = 1;
									} else {
									row = 0;
									}
							
							});
							
							$( "#eventstable tbody" ).on("click", "a", getID);
							console.log("showTable click listener");
						} else if ($phase == 'getEvent') {
					
							$.each(response, function(i, item) {
								$('div.title-d', parentBody).html(item.event_title);
								$('div.location-d', parentBody).html(item.event_location);
								$('div.datetime-d', parentBody).html(item.start);
								$('div.description-d', parentBody).html(item.event_details);
								$('a.closer', parentBody).show();
								$('.printer', parentBody).show();
								$('div.framer', parentBody).show('fold', 700);
								console.log('Event completed');
							});
						
							$('a.closer', parentBody).on("click",function(){
								console.log('func  closerAction fired');
								$('div.printer', parentBody).show();
								$('div.closer', parentBody).show();
								$('div.framer', parentBody).hide('fold', 300);
							});
						}
					
				},
				error: function(xhr, desc, err) {
					$('tbody').html('<p style="text-align: center; font-size: 40px; color: red; background: #fff;">FAIL</p>');
					console.log('phase: ' + $phase);
					console.log("Details: " + desc + "\nError:" + err);
					console.dir(xhr);
				}
			}); //close actual ajax func
		} //close RunAjax
		
		function getID(event) {  
				$eventIdToGet = $(this).attr('id');
				console.log('user chose id ' + $eventIdToGet);
				event.preventDefault();	
				$phase = "getEvent";
				$('#eventstable').RunAjax($phase,$eventIdToGet);		//second pass
				
		 }
		 
	


		$('#eventstable').RunAjax();		//first pass
		
			
	});	



		
	