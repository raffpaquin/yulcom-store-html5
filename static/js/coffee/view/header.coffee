class Yulcom.View.Header extends Backbone.View

	el: $("header")
	template:'page/header'

	initialize: ->
		app.customer.on 'change:is_login', @render
		#app.customer.on 'change:is_login', ->
		#	alert 'changing'

	render: ->
		_this = @
		app.template.loadTemplateHtml @template, ->
			$('header').html app.template.render _this.template 