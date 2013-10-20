window.app =
	debug:false
	collections:{}
	models:{}
	views:{}
	config:{}
app = window.app
$ = window.$
_ = window._
Backbone = window.Backbone
Modernizr = window.Modernizr
Handlebars = window.Handlebars

#Gave Event Capabilities to the APP
_.extend app, Backbone.Events

app.init = () ->
	@

app.get = (key) ->
	@config[key]

app.config = window.configs