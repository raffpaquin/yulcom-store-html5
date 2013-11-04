class Yulcom.Router extends Backbone.Router
	routes:
		'login(/)':			'login'
		'products(/)':		'product'
		'products/:key(/)':	'productView'
		'cart(/)':			'cart'
		'checkout(/)':		'checkout'
		'help(/)':			'help'
		'profil(/)':		'profil'
		'error(/)(:number)':'error'
		'logout(/)':		'logout'
		'':					'home'
		':path':			'error'

	initialize: ->
		Backbone.history.start
			pushState: true


	load: (page_definition) ->
		app.views.page.load page_definition

	reload: ->
		Backbone.history.stop()
		Backbone.history.start()

	redirect: (url) ->
		@navigate url,
				trigger:true


	home: ->
		app.views.page.reset()
		app.views.page.loadTemplate 'index'
		app.views.page.load
			menu:'index'

	login: ->
		if app.customer.isLogin()
			@redirect '/'
		else
			app.views.page.reset()
			app.views.page.loadTemplate 'login'
			app.views.page.load
				menu:'login'

	product: ->
		app.views.page.reset()
		app.views.page.loadCollection 'products', app.collections.products
		app.views.page.loadTemplate 'product/list'
		app.views.page.load
			menu:'products'

	productView: (product_id) ->
		app.views.page.reset()
		app.views.page.loadModel 'product', new app.models.product {id:product_id}
		app.views.page.loadTemplate 'product/view'
		app.views.page.load
			menu:'products'

	cart:->
		if app.customer.isLogin()
			app.views.page.reset()
			app.views.page.loadModel 'cart', app.models.cart
			app.views.page.loadTemplate 'cart/cart'
			app.views.page.load
				menu:'cart'
		else
			@redirect '/login'

	checkout:->
		if app.customer.isLogin()
			app.views.page.reset()
			app.views.page.action = new Yulcom.View.Checkout
			app.views.page.loadModel 'cart', app.models.cart
			app.views.page.loadCollection 'address', app.collections.address
			app.views.page.loadCollection 'cc', app.collections.cc
			app.views.page.loadTemplate 'checkout/checkout'
			app.views.page.callback app.views.page.action.init
			app.views.page.load
				menu:'cart'
		else
			@redirect '/login'

	logout: ->
		app.customer.logout()
		location.href = '/'




$ ->
	$(".wrapper").on "click","a", (e) ->
		# touchstart est aussi un click (300ms après click) ça doublerait l'action
		href = $(this).attr "href"
		if href and href.length > 1 && href.substring(0,3) != 'tel' && href.substring(0,4) != 'http' && href != '#nav'
			app.router.redirect href
			e.preventDefault()


