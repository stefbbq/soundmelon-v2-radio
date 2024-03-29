//Players Manager
var ytPlayer, scWidget, scWidgetManager, bufferInterval, bufferLength, ytFirstPlayForSong;

var SMplayersManager = function($scAppId) {
	var scAppId = $scAppId;
	var playerHeight = '320';
	var playerWidth = '564';

	scWidgetManager = SMscWidgetManager();

	// function loadInterval(song) {
	// 	if(song.upload_source === "soundcloud") {
	// 		scWidget.load().play();
	// 	}
	// 	else if(song.upload_source === "youtube") {
	// 		ytPlayer.stopVideo().playVideo();
	// 	}
	// 	var message = {
	// 		severity: "Standby",
	// 		message: "Servers are slow today, please wait!"
	// 	}
	// 	FlashManager.showMessage(message);
	// }
	
	function initSCPlayer() {
		//Load the SC player the first time a SC file is streamed in session
		SC.initialize({
			//client_id: '#{ENV["SOUNDCLOUD_APP_ID"]}'
			client_id: scAppId
		});
		scPlayerReady = true;
		runInitSC = true;
	}

	function loadSCSong(song) {
		console.log('about to stream!');
		// bufferInterval = setInterval(function() {loadInterval(song)}, 5000);
		SC.stream('/tracks/' + song['song_id'], {
			preferFlash: false,
			onfinish: function() {
					console.log('finished this SC song...');
					scrubInterval.stop();
					$('#play-pause .control-image').removeClass('play-image pause-image').addClass('spinner ');
					RadioManager.disableNextButton();
					RadioManager.playNextSong();
			},
			onresume: function() {

				$('#play-pause .control-image').removeClass('spinner ').addClass('pause-image').show();
			},
			onstop: function() {
				scrubInterval.stop();
				$('#play-pause .control-image').removeClass('spinner ').addClass('play-image').show();
			},
			onpause: function() {
				scrubInterval.stop();
				console.log("This SC is paused, scrubinterval is closed");
				$('#play-pause .control-image').removeClass('spinner ').addClass('play-image').show();
			},
			onplay: function() {
				// alert('ready!');
				// clearInterval(bufferInterval);
				RadioManager.enableNextButton();
				$('#play-pause .control-image').removeClass('spinner ').addClass('pause-image').show();
				scrubInterval.start();
				console.log('onplay SC'); 
			},
			onready: function() {

				
			}
			}, function(sound) {
				scWidget = sound;
				console.log(scWidget);
				scWidgetManager.addSong(sound);
				playSCTrack();
			});
	}
	
	function playSCTrack() {
		console.log('should play now...');
		scWidget.setVolume(volume);
		scWidget.play();
		// scrubInterval.start()
	}
	
	
	function setQuality(level) {
		ytPlayer.setPlaybackQuality(level);
	}
	
	function onYouTubeIframeAPIReady() {
		console.log('onto the YT');
		ytPlayer = new YT.Player('youtube', {
			playerVars: {
				'rel': 0,
				'html5': 1,
				'controls': 0,
				'showinfo': 0
			},
			height: playerHeight,
			width: playerWidth,
			events: { 
				'onReady': ytOnReady,
				'onPlaybackQualityChange': ytPlaybackQualityChange,
				'onStateChange': ytStateChange,
				'onError': ytError
			}
		});
		console.log(ytPlayer.b.b.events);
	}
	
	function ytOnReady() {
		ytPlayerReady = true;
		console.log('yt is now ready!');
		setQuality(ytQuality);
		// console.log(event);
		RadioManager.executePlaylist();
	}
	
	function ytPlaybackQualityChange() {
		console.log(ytPlayer.getPlaybackQuality());
	}
	
	function ytStateChange() {
		// console.log(event.data);
		var state = ytPlayer.getPlayerState();
		if(state === 0) {
			// state ended

			scrubInterval.stop();
			RadioManager.disableNextButton();
			$('#play-pause .control-image').removeClass('play-image pause-image').addClass('spinner ');
			RadioManager.playNextSong();
		}
		else if(state === 1) {
			// state playing

			RadioManager.enableNextButton();
			$('#play-pause .control-image').removeClass('spinner ').addClass('pause-image').show();
			if(ytPlayer.getPlaybackQuality !== ytQuality) {
				setQuality(ytQuality);
			}
			if(ytFirstPlayForSong) {
				scrubInterval.start();
				ytFirstPlayForSong = false;
			}
			if(!scrubInterval.isRunning()) scrubInterval.start();
		}
		else if(state === 2) {
			// state paused

			scrubInterval.stop();
			$('#play-pause .control-image').removeClass('spinner').removeClass('pause-image').addClass('play-image').show();
			
		}
		else if(state === 3) {
			// state buffering 

			$('#play-pause .control-image').removeClass('play-image pause-image').addClass('spinner ');
		}
		else if(state === 5) {
			// state queued
		}
	}
	
	function ytError() {
		// console.log(event);
		if(/100|101|150/.test(event.data)) {
			RadioManager.playNextSong();
		}
	}
	
	return {
		onYouTubeIframeAPIReady: onYouTubeIframeAPIReady,
		initSCPlayer: initSCPlayer,
		loadSCSong: loadSCSong,
		playSCTrack: playSCTrack
		// loadInterval: loadInterval
	}
}