app.checkout = 
	goTo: (section) ->
		$('.checkout-panel').animate
			opacity:0
			left:'-200px'
		,200, 'swing', ->
			$('.checkout-panel li').hide 0
			$('.checkout-progress li').removeClass 'active'
			$('.checkout-progress li.progress-'+section).addClass 'active'
			$('.checkout-panel li.step-'+section).show 0
			$('.checkout-panel').css
				'left':'200px'


			$('.checkout-panel').animate
				opacity:1
				left:0
			,200

		true