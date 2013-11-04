app.template = 
	engines: []
	requested: []
	callback: {}

	render: (template_id, object) ->
		#Base Object
		object = $.extend {customer:app.customer.toJSON()}, object
		if @engines[template_id]
			console.log object
			@engines[template_id] object
		else
			alert 'Unknow Template Engine'

	block: (template_id, jquery_container) ->
		content_html = @render template_id
		$container = $ jquery_container
		$container.html content_html
		true

	loadTemplateHtml: (template_id, callback) ->
		#Does the template engine exists?
		if not @engines[template_id]
			if not @requested[template_id]
				@requested[template_id] = true
				@callback[template_id] = [callback]
			
				$.ajax
					url:'/static/template/'+template_id+'.mustache'
					context:
						engines:@engines
						template_id:template_id
						callback:@callback
					success: (response) ->
						#Render the Template Engine
						@engines[@template_id] = Handlebars.compile response

						#Call all the callbacks
						callback() for callback in @callback[@template_id]
					cache:true
					dataType:'html'
			else
				@callback[template_id].push callback
		else
			callback()


Handlebars.registerHelper 'round', (context) ->
	Math.round context

Handlebars.registerHelper 'money', (context) ->
	context = parseFloat context
	
	if context >= 0
		'$'+context.toFixed(2)
	else
		money = -1*context
		'$' + money.toFixed(2) + ''

	
	

Handlebars.registerHelper 'time', (context) ->
	window.moment(context*1000).from()


