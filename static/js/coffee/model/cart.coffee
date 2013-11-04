class Yulcom.Model.Cart extends Yulcom.Model.Base
	
	is_loaded:false

	url: ->
		app.get('api')+'cart/'

	item:
		add: (item) ->
			app.load true, '.page-product'
			app.api.post
				url:'cart/product/add'
				data:
					product_id:item
				success: (response) ->
					app.load false
					if 'success' == response.status
						app.models.cart.set response.data
						app.models.cart.is_loaded = true
						app.router.redirect 'cart'
					else
						app.error response.message

		remove: (item_id) ->
			app.load true, '.main-cta'
			app.api.post
				url:'cart/product/remove'
				data:
					item_id:item_id
				context:
					item_id:item_id
				success: (response) ->
					if 'success' == response.status
						$(".item-"+item_id).fadeOut 300, ->
							app.load false
							app.models.cart.set response.data
							app.models.cart.is_loaded = true
							app.router.reload 'cart'
					else
						app.error response.message
			$(".item-"+item_id).animate
				opacity:0.5,
			200

	coupon:
		add: (coupon) ->
			app.load true, '.cart-form-coupon'
			app.api.post
				url:'cart/coupon'
				data:
					coupon:coupon
				success: (response) ->
					app.load false
					if 'success' == response.status
						app.models.cart.set response.data
						app.models.cart.is_loaded = true
						app.router.reload 'cart'
					else
						app.error response.message
						$('input').first().select()
		remove: ->
			@add ''
