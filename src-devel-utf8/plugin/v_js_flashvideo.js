 window.focus();
	flowplayer("player", "$basehref$::skin_url/flowplayer-3.2.7.swf",
		{
			clip: {
				url: '$flvpath',
				autoPlay: true,
				autoBuffering: true,
				scaling: 'fit'
			},
			canvas: {
				backgroundColor: '#000000',
				backgroundGradient: 'none'
		},
		plugins: {
			controls: {
				height: 24,
				play:true,
				stop:true,
				volume:true,
				mute:true,
				time:true,
				fullscreen:true,
				volumeSliderColor: '#000000',
				tooltipColor: '#5F747C',
				progressColor: '#112233',
				bufferColor: '#445566',
				buttonColor: '#5F747C',
				sliderColor: '#000000',
				backgroundGradient: 'high',
				durationColor: '#ffffff',
				backgroundColor: '#222222',
				progressGradient: 'medium',
				borderRadius: '0',
				buttonOverColor: '#728B94',
				bufferGradient: 'none',
				timeBgColor: '#555555',
				sliderGradient: 'none',
				volumeSliderGradient: 'none',
				tooltipTextColor: '#ffffff',
				timeColor: '#01DAFF'
			 }
		}
	}
);
