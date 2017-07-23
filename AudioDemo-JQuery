//The following is general navigation code related to audio file selection and playback on the visual impairment audio site
//Created 2014 by Jeff Epstein for the Alzheimer's Association, Massachusetts and New Hampshire
$(document).ready(function(){
	//get the id of the clicked element and find the closest li element
	$(" a ").click(function(event){
		event.preventDefault();
		$("#player").remove();					//close any open player		
		var srcstring = this.id;
		var myItem = $(this).closest('li');
		
		if (Modernizr.audio) {					//use the html5 audio object if supported
			myItem.append(
			'<div id="player"><audio controls>' + '<source class="audiosource" src="files/' + srcstring + '.mp3" type="audio/mpeg" />' + '<source class="audiosource" src="files/' + srcstring + '.ogg" type="audio/ogg" />' + 'Your browser does not support the audio element.' + '</audio>' + '</div>');
			var myAudio=$(".audiosource");     
			$("audio").load();
			$("#player").show();
		} else {								 //if no html5, use flash if supported. We provide a download link for contingencies.
			if ($.flash.available) {
				myItem.append('<div id="player"></div>');
				$('div#player').flash({
					swf: 'dewplayer/dewplayer-multi.swf',
					flashvars: 'mp3=files/' + srcstring + '.mp3',
					wmode: 'transparent',
					width: 320,
					height: 30
					});
				$('div#player').append('<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Please <a href="files/' + srcstring + '.mp3" >' + 'download the file' + '</a> if player above fails.<br /><br />');
				$('div#player').show();
			} else {  	//if flash fails just offer download link
				myItem.append('<div id="player"><a href="files/' + srcstring + '.mp3" />' + 'No Player. Please Download' + '</a></div>');
			}
		}
	});  //close click handler
});	//close jquery

					
	
