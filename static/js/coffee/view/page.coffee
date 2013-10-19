ViewPage = Backbone.View.extend

	el:$('#content')
	ressources:
		template:null
		template_isLoaded:false
		data:null
		data_isLoaded:false


		
	initialize: ->
		@render()

	load: (page) ->
		$('body').addClass 'loading'

		@ressources.template = null
		@ressources.template_isLoaded = false
		@ressources.data_isLoaded = false

		if page.menu
			$('ul.menu li').removeClass 'active'
			$('ul.menu li[data-href='+page.menu+']').addClass 'active'

		if page.template
			@ressources.template = page.template
			app.template.loadTemplateHtml page.template, (response) ->
				app.views.page.ressources.template_isLoaded = true
				app.views.page.render()
		else
			@template_loaded = true

		if page.data
			page.data.success = (response) ->
				app.views.page.ressources.data = response
				app.views.page.ressources.data_isLoaded = true
				if response.status == 'error'
					app.controller.redirect '/'
				else
					app.views.page.render()
			page.data.error = (response) ->
				alert 'error loading ajax ressources'
			app.api.post page.data
		else
			@ressources.data_isLoaded = true

		@render()

	render: ->
		if @ressources.template_isLoaded and @ressources.data_isLoaded
			@$el.html app.template.render @ressources.template, @ressources.data
			$('body').removeClass 'loading'
			$('body').scrollTop 0


