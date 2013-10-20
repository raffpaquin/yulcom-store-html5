ViewPage = Backbone.View.extend

	el:$('#content')
	ressources:
		template:null
		collection:[]
		model:[]

	queue:
		template:0
		collection:0
		model:0

	data:{}


	#initialize: ->
	#	@render()

	reset: ->
		@data = {}
		@ressources = 
			template:null
			collection:{}
			model:{}
		queue:
			template:0
			collection:0
			model:0

	loadCollection: (key, collection) ->
		@ressources.collection[key] = collection
		@queue.collection++
		@ressources.collection[key].fetch
			success: ->
				self = app.views.page
				self.data[key] = collection.toJSON()
				self.queue.collection--
				self.render()

	loadModel: (key, model) ->
		model.bind 'sync', ->
			self = app.views.page
			self.data[key] = model.toJSON()
			self.queue.model--
			self.render()
		@ressources.model[key] = model
		@queue.model++
		@ressources.model[key].fetch()

	loadTemplate: (template_id) ->
		@ressources.template = template_id
		@queue.template++
		app.template.loadTemplateHtml template_id, (response) ->
			self = app.views.page
			self.queue.template--
			self.render()

	load: (page) ->
		$('body').addClass 'loading'


		if page.menu
			$('ul.menu li').removeClass 'active'
			$('ul.menu li[data-href='+page.menu+']').addClass 'active'

		@render()

	render: ->
		num = new Date().getTime()
		alert num+' - '+@queue.template
		alert num+' - '+@queue.model
		alert num+' - '+@queue.collection
		if @queue.template == 0 and @queue.model == 0 and @queue.collection == 0 
			console.log @data
			@$el.html app.template.render @ressources.template, @data
			$('body').removeClass 'loading'
			$('body').scrollTop 0


