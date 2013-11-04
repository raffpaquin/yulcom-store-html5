window.app =
	debug:false
	collections:{}
	models:{}
	views:{}
	config:{}
window.Yulcom = 
	Collection:{}
	Model:{}
	View:{}
app = window.app
Yulcom = window.Yulcom
$ = window.$
_ = window._
Backbone = window.Backbone
Modernizr = window.Modernizr
Handlebars = window.Handlebars
Backbone.emulateHTTP = true

#Gave Event Capabilities to the APP
_.extend app, Backbone.Events

app.init = () ->

	#Models
	@customer = new Yulcom.Model.Customer()
	@models.cart = new Yulcom.Model.Cart()
	@customer.init()

	#Collections
	@collections.products = new Yulcom.Collection.Product()
	@collections.address = new Yulcom.Collection.Address()
	@collections.cc = new Yulcom.Collection.Cc()

	#Views
	@views.header = new Yulcom.View.Header()
	@views.page = new Yulcom.View.Page() 
	@views.header.render()

	#Controllers
	@router = new Yulcom.Router()	


	@

app.get = (key) ->
	@config[key]

app.error = (msg = 'Unknown Server Error', scope = 'body') ->
	if '' == msg
		if $('.alert',scope).length > 0
			$('.alert',scope).slideUp 200
	else
		if $('.alert',scope).length > 0
			$('.alert',scope).first().text(msg).slideDown 200
		else
			alert msg

app.load = (active = true, scope = 'body') ->
	$('.btn',scope).toggleClass 'loading', active
	if active
		@error ''

app.config = window.configs