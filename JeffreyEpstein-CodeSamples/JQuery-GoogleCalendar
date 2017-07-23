$(document).ready(function() {
	$('#calendar').fullCalendar({
		googleCalendarApiKey: ' REDACTED FOR DEMO ',  //our API key
		events: {googleCalendarId: 'REDACTED FOR DEMO'
					},
		eventBackgroundColor: '#65378e',
		header: {
			left: "title",
			center: ' ',
			right:  'prev next'
		},
		theme: true,
		themeButtonIcons: false,
		eventClick: function(gcalEvent, jsEvent, view) {
			gcalEvent.preventDefault ? gcalEvent.preventDefault() : gcalEvent.returnValue = false;  //IE8 does not recognize preventDefault so use returnvalue=false
			var eid = gcalEvent.id;
			var etitle = gcalEvent.title;
			//var eurl = gcalEvent.url;
			//var estart = $.fullCalendar.formatDate(gcalEvent.start, 'MMMM d'+', '+'h:mm tt ');
			//var eend = $.fullCalendar.formatDate(gcalEvent.end, 'h:mm tt');
			var elocation = gcalEvent.location;
			var edescription = gcalEvent.description;
			var eallday = gcalEvent.allDay;
			$('div.title-d').html(etitle);
			//$('div.datetime-d').html(estart + "-" +eend);
			$('div.location-d').html(elocation);
			$('div.description-d').html(edescription);
			$('div.framer').css({'background' : 'rgb(234,191,73)'});	// and do the same for the detail framer					
			gcalEvent.preventDefault ? gcalEvent.preventDefault() : gcalEvent.returnValue = false;  //IE8 does not recognize preventDefault so use returnvalue=false
			return false;
		}
	});
});
