app.checkout = 
	current_page:null
	order:
		'shipping-address':1
		'billing-address':2
		'payment-method':3
		'review':4

	init: ->
		@current_page = null
		@goTo 'shipping-address'
	goTo: (section) ->


		#Already open
		if section == @current_page
			return

		#Does section exists?
		if not @order[section]?
			return

		if $('.checkout-panel li.step-'+section).length == 0
			setTimeout ->
				app.checkout.goTo section
			, 200
			return
		

		#Decide if we go right or left
		if @order[section] >  @order[@current_page]
			delta = -1
		else
			delta = 1



		$('.checkout-panel').animate
			opacity:0
			left:(200 * delta) + 'px'
		,200, 'swing', ->
			$('.checkout-panel li').hide 0
			$('.checkout-progress li').removeClass 'active'
			$('.checkout-progress li.progress-'+section).addClass 'active'
			$('.checkout-panel li.step-'+section).show 0
			$('.checkout-panel').css
				'left':(-1 * 200 * delta) + 'px'

			$('.checkout-panel').animate
				opacity:1
				left:0
			,200, 'swing', ->
				#Auto focus on the first input
				$('.checkout-panel li.step-'+section+' input').first().focus()
				if section == 'payment-method'
					$('input.cc-num').payment 'formatCardNumber'
				

		@current_page = section

		true

	saveSection: (section) ->
		switch section
			when 'shipping-address' 
				@goTo 'billing-address'
			when 'billing-address' 
				@goTo 'payment-method'
			when 'payment-method' 
				@goTo 'review'
			when 'review' 
				alert 'ORDER BITCHES!'

	toggleForm: (section) ->
		$form = $ 'form', '.step-'+section
		$list = $ '.form-list', '.step-'+section
		if $form.is ':visible'
			$form.fadeOut 100, ->
				$list.fadeIn 100
		else
			$list.fadeOut 100, ->
				$form.fadeIn 100

				