AppController = Backbone.Router.extend
	_page:null
	routes:
		
		
		#'home(/)':			'home'

		'login(/)':			'login'
		'products(/)':		'product'
		'products/:key(/)':	'product-view'
		'cart(/)':			'cart'
		'checkout(/)':		'checkout'
		'help(/)':			'help'
		'profil(/)':		'profil'


		'error(/)(:number)':'error'
		'logout(/)':		'logout'
		'':					'home'
		':path':			'error'

	initialize: ->
		app.views.page = new ViewPage



	load: (page_definition) ->
		app.views.page.load page_definition

	reload: ->
		Backbone.history.stop()
		Backbone.history.start()

	redirect: (url) ->
		app.controller.navigate url,
				trigger:true



app.controller = new AppController	


app.controller.on 'route:home', ->
	app.views.page.load
		template:'index'
		menu:'index'

app.controller.on 'route:login', ->
	app.views.page.load
		template:'login'
		menu:'login'

app.controller.on 'route:product', ->
	app.views.page.load
		template:'product/list'
		menu:'products'

app.controller.on 'route:product-view', ->

	app.views.page.load
		template:'product/view'
		menu:'products'

app.controller.on 'route:cart', ->
	app.views.page.load
		template:'cart/cart'
		menu:'cart'

app.controller.on 'route:checkout', ->
	app.views.page.load
		template:'checkout/checkout'
		menu:'cart'

app.controller.on 'route:product-view', (product_id) ->
	if app.models.customer.isLogin()
		app.views.page.load
			template:'product/view'
			data:
				url:'product/view'
				data:
					id:product_id
				type:'get'
			menu:'product'

app.controller.on 'route:product-add', ->
	if app.models.customer.isLogin()
		app.views.page.load
			template:'product/add'
			menu:'product'



app.controller.on 'route:order', ->
	if app.models.customer.isLogin()
		app.views.page.load
			template:'order/index'
			data:
				url:'order/list'
				type:'get'
			menu:'order'
		
app.controller.on 'route:order-view', (order_id) ->
	if app.models.customer.isLogin()
		app.views.page.load
			template:'order/view'
			data:
				url:'order/view'
				data:
					id:order_id
				type:'get'
			menu:'order'




app.controller.on 'route:promotion', ->
	if app.models.customer.isLogin()
		app.views.page.load
			template:'promotion/index'
			data:
				url:'coupon/list'
				type:'get'
			menu:'promotion'

app.controller.on 'route:promotion-add', ->
	if app.models.customer.isLogin()
		app.views.page.load
			template:'promotion/add'
			menu:'promotion'

app.controller.on 'route:analytic', ->
	if app.models.customer.isLogin()
		app.views.page.load
			template:'analytic/index'
			menu:'analytic'

app.controller.on 'route:setting', ->
	if app.models.customer.isLogin()
		app.views.page.load
			template:'setting/index'
			menu:'setting'
			
app.controller.on 'route:home-redirect', ->
	app.controller.redirect 'home'

app.controller.on 'route:logout', ->
	if app.models.customer.isLogin()
		app.models.customer.logout()



Backbone.history.start
	pushState: true

$ ->
	$(".wrapper").on "click","a", (e) ->
		# touchstart est aussi un click (300ms après click) ça doublerait l'action
		href = $(this).attr "href"
		if href and href.length > 1 && href.substring(0,3) != 'tel' && href.substring(0,4) != 'http' && href != '#nav'
			app.controller.redirect href
			e.preventDefault()


