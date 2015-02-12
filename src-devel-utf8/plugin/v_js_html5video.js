	window.focus();
	VideoJS.setupAllWhenReady();
	VideoJS.DOMReady(function(){
		var myPlayer = VideoJS.setup("playvideo");
		var myManyPlayers = VideoJS.setup("All");
		myPlayer.play();
	});
	VideoJS.setupAllWhenReady({
		controlsBelow: false,
		controlsHiding: true,
		defaultVolume: 0.85,
		flashVersion: 9,
		linksHiding: true
	});
