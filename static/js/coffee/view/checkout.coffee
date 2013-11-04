class Yulcom.View.Checkout extends Yulcom.View.Page 
	current_page:null
	order:
		'shipping-address':1
		'billing-address':2
		'payment-method':3
		'review':4

	init: ->
		self = app.views.page.action
		self.current_page = null
		self.goTo 'shipping-address'
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

	saveSection: (section, data = false) ->
		switch section
			when 'shipping-address' 
				app.load true

				#Do we want to create a new address?
				if data == false
					#Create a new address
					data = app.api.stringToJson $('form#form-shipping-address').serialize()
					app.views.page.action.saveAddress data, (model, response) ->
						if 'success' == response.status
							app.views.page.action.saveShippingAddress response.data.address_id
						else
							app.load false
							app.error response.message
				else
					#Only push address to checkout endpoint
					app.views.page.action.saveShippingAddress data


				
			when 'billing-address' 
				@goTo 'payment-method'
			when 'payment-method' 
				@goTo 'review'
			when 'review' 
				alert 'ORDER BITCHES!'

	saveAddress: (addressData, callback) ->
		shippingAddress = new Yulcom.Model.CustomerAddress()
		shippingAddress.save
			address:addressData
		,
			success: callback
			error: (response) ->
				app.error 'Unknown server error'
				app.load false
			wait: true

	saveShippingAddress: (addressId, callback) ->
		#Push to address_id to checkout	
		app.api.post
			url:'cart/shipping-address'
			data:
				address_id:addressId
			success: (response) ->
				if 'success' == response.status
					if $('input[name=same-as-shipping]').is(':checked')
						app.views.page.action.goTo 'payment-method'
					else
						app.views.page.action.goTo 'billing-address'
				else
					app.error response.message
				app.load false
			error: (response) ->
				app.error()

	toggleForm: (section) ->
		$form = $ 'form', '.step-'+section
		$list = $ '.form-list', '.step-'+section
		if $form.is ':visible'
			$form.fadeOut 100, ->
				$list.fadeIn 100
		else
			$list.fadeOut 100, ->
				$form.fadeIn 100