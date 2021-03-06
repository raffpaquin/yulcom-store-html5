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
			$('.checkout-panel li.step').hide 0
			$('.checkout-progress li').removeClass 'active'
			$('.checkout-progress li.progress-'+section).removeClass 'not-ready'
			if section == 'payment-method'
				$('.checkout-progress li.progress-billing-address').removeClass 'not-ready'
			
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
				if $('.step-shipping-address form').is(':visible')
					#Create a new address
					data = app.api.stringToJson $('form#form-shipping-address').serialize().replace(/\+/g,'%20')
					app.views.page.action.saveAddress data, (model, response) ->
						if 'success' == response.status
							app.views.page.action.saveShippingAddress response.data.address_id
						else
							app.load false
							app.error response.message
				else
					#Only push address to checkout endpoint
					if data == false
						app.load false
						if $('.step-shipping-address .form-list li.active').length > 0
							if $('input[name=same-as-shipping]').is(':checked')
								app.views.page.action.goTo 'payment-method'
							else
								app.views.page.action.goTo 'billing-address'
						else
							app.error 'Please select an address', '.step-shipping-address .form-list'
					else
						app.views.page.action.saveShippingAddress data
			when 'billing-address' 
				app.load true

				#Do we want to create a new address?
				if $('.step-billing-address form').is(':visible')
					#Create a new address
					data = app.api.stringToJson $('form#form-billing-address').serialize().replace(/\+/g,'%20')
					app.views.page.action.saveAddress data, (model, response) ->
						if 'success' == response.status
							app.views.page.action.saveBillingAddress response.data.address_id
						else
							app.load false
							app.error response.message
				else
					#Only push address to checkout endpoint
					if data == false
						app.load false
						if $('.step-billing-address .form-list li.active').length > 0
							app.views.page.action.goTo 'payment-method'
						else
							app.error 'Please select an address', '.step-billing-address .form-list'
						
					else
						app.views.page.action.saveBillingAddress data
					
			when 'payment-method' 
				app.load true

				if $('.step-payment-method form').is(':visible')
					#Create new cc
					#number,cvc,exp_month,exp_year

					data = app.api.stringToJson $('form#form-payment').serialize().replace(/\+/g,'%20')
					app.views.page.action.saveCc data, (model, response) ->
						if 'success' == response.status
							app.views.page.action.saveCcCheckout response.data.cc_id
						else
							app.load false
							app.error response.message
				else
					#Only push address to checkout endpoint
					if data == false
						app.load false
						if $('.step-payment-method .form-list li.active').length > 0
							app.views.page.action.goTo 'review'
						else
							app.error 'Please select a payment method', '.step-payment-method .form-list'
					else
						app.views.page.action.saveCcCheckout data
					
			when 'review' 
				app.load true
				app.api.post
					url:'cart/order'
					success: (response) ->
						if 'success' == response.status
							#Load a new page
							app.views.page.reset()
							app.views.page.loadJSON 'order', response.data
							app.views.page.loadTemplate 'checkout/confirm'
							app.views.page.load
								menu:'cart'
						else
							app.error response.message
						app.load false
					error: (response) ->
						app.error()
						app.load false

	saveAddress: (addressData, callback) ->
		shippingAddress = new Yulcom.Model.CustomerAddress()
		shippingAddress.save addressData
		,
			success: (model, response) ->
				if 'success' == response.status
					model.set '_id', response.data.address_id
					app.collections.address.add model
					app.views.page.refreshCollection 'address'
				callback model, response
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
					sameAsShippingForBilling = $('input[name=same-as-shipping]').is(':checked')
					#Update checkout (cart) models & collections
					app.models.cart.set response.data
					app.views.page.refreshModel 'cart'
					
					#Update checkout views
					app.views.page.refreshSubView 'checkout/step_billing_address'
					app.views.page.refreshSubView 'checkout/step_shipping_address'
					app.views.page.refreshSubView 'checkout/step_review'

					if sameAsShippingForBilling
						app.views.page.action.goTo 'payment-method'
					else
						app.views.page.action.goTo 'billing-address'
				else
					app.error response.message
				app.load false
			error: (response) ->
				app.error()

	saveBillingAddress: (addressId, callback) ->
		#Push to address_id to checkout	
		app.api.post
			url:'cart/billing-address'
			data:
				address_id:addressId
			success: (response) ->
				if 'success' == response.status
					#Update checkout (cart) models & collections
					app.models.cart.set response.data
					app.views.page.refreshModel 'cart'
					
					#Update checkout views
					app.views.page.refreshSubView 'checkout/step_billing_address'
					app.views.page.refreshSubView 'checkout/step_shipping_address'
					app.views.page.refreshSubView 'checkout/step_review'
					app.views.page.action.goTo 'payment-method'
				else
					app.error response.message
				app.load false
			error: (response) ->
				app.error()



	saveCc: (ccData, callback) ->
		ccData.number = ccData.number.replace /\+/g,''
		window.Stripe.createToken ccData, (code, response) ->
			if response.error
				app.error response.error.message, 'form#form-payment'
				$('form#form-payment input[name='+response.error.param+']').select()
				app.load false
			else
				cc = new Yulcom.Model.CustomerCc()
				cc.save
					token:response.id
				,
					success: (model, response) ->
						if 'success' == response.status
							model.set '_id', response.data.cc_id
							app.collections.cc.add model
							app.views.page.refreshCollection 'cc'
						callback model, response
					error: (response) ->
						app.error()
						app.load false
					wait: true


	saveCcCheckout: (token_id) ->
		#Push to address_id to checkout	
		app.api.post
			url:'cart/cc'
			data:
				cc_id:token_id
			success: (response) ->
				if 'success' == response.status
					#Update checkout (cart) models & collections
					app.models.cart.set response.data
					app.views.page.refreshModel 'cart'
					
					#Update checkout views
					app.views.page.refreshSubView 'checkout/step_payment'
					app.views.page.refreshSubView 'checkout/step_review'

					app.views.page.action.goTo 'review'
				else
					app.error response.message
				app.load false
			error: (response) ->
				app.error()
				app.load false



	toggleForm: (section) ->
		$form = $ 'form', '.step-'+section
		$list = $ '.form-list', '.step-'+section
		if $form.is ':visible'
			$form.fadeOut 100, ->
				$list.fadeIn 100
		else
			$list.fadeOut 100, ->
				$form.fadeIn 100