var ytPlayer,scWidget,SMplayersManager=function(a){function e(){SC.initialize({client_id:y}),scPlayerReady=!0,runInitSC=!0}function l(a){console.log("about to stream!"),SC.stream("/tracks/"+a.song_id,{preferFlash:!1,onfinish:function(){console.log("finished this SC song..."),clearInterval(scrubInterval),$("#play-pause .control-image").removeClass("play-image pause-image").addClass("loading-image"),$(".seek-scrub").addClass("disable"),RadioManager.playNextSong()},onresume:function(){$("#play-pause .control-image").removeClass("loading-image").addClass("pause-image")},onstop:function(){$("#play-pause .control-image").removeClass("loading-image").addClass("play-image")},onpause:function(){$("#play-pause .control-image").removeClass("loading-image").addClass("play-image")},onplay:function(){$(".seek-scrub").removeClass("disable"),$("#play-pause .control-image").removeClass("loading-image").addClass("pause-image")}},function(a){scWidget=a,o()})}function o(){console.log("should play now..."),scWidget.setVolume(volume),scWidget.play(),scrubInterval=setInterval(RadioManager.seekTracker,scrubDelay)}function s(a){ytPlayer.setPlaybackQuality(a)}function n(){console.log("onto the YT"),ytPlayer=new YT.Player("youtube",{playerVars:{rel:0,html5:1,controls:0,showinfo:0},height:c,width:u,events:{onReady:t,onPlaybackQualityChange:i,onStateChange:r,onError:g}}),console.log(ytPlayer.b.b.events)}function t(){ytPlayerReady=!0,console.log("yt is now ready!"),s(ytQuality),console.log(event),RadioManager.executePlaylist()}function i(){console.log(ytPlayer.getPlaybackQuality())}function r(){console.log(event.data);var a=ytPlayer.getPlayerState();0===a?(clearInterval(scrubInterval),$(".seek-scrub").addClass("disable"),$("#play-pause .control-image").removeClass("play-image pause-image").addClass("loading-image"),RadioManager.playNextSong()):1===a?(scrubInterval=setInterval(RadioManager.seekTracker,scrubDelay),$(".seek-scrub").removeClass("disable"),$("#play-pause .control-image").removeClass("loading-image").addClass("pause-image"),ytPlayer.getPlaybackQuality!==ytQuality&&s(ytQuality)):2===a?$("#play-pause .control-image").removeClass("loading-image").addClass("play-image"):3===a&&$("#play-pause .control-image").removeClass("play-image pause-image").addClass("loading-image")}function g(){console.log(event),/100|101|150/.test(event.data)&&RadioManager.playNextSong()}var y=a,c="320",u="564";return{onYouTubeIframeAPIReady:n,initSCPlayer:e,loadSCSong:l,playSCTrack:o}};