class Yulcom.View.Page extends Backbone.View

	el:$('#content')
	ressources:
		template:null
		collection:[]
		model:[]

	queue:
		template:0
		collection:0
		model:0
		callback:[]

	data:{}
	action:{}


	#initialize: ->
	#	@render()

	reset: ->
		@data = {}
		@action = {}
		@ressources = 
			template:null
			collection:{}
			model:{}
		queue:
			template:0
			collection:0
			model:0
			callback:[]

	loadCollection: (key, collection) ->
		@ressources.collection[key] = collection

		if typeof(collection.is_loaded) == 'undefined' or collection.is_loaded == false
			@queue.collection++
			@ressources.collection[key].fetch
				success: ->
					self = app.views.page
					self.data[key] = collection.toJSON()
					self.queue.collection--
					self.render()
		else
			@data[key] = collection.toJSON()

	loadModel: (key, model) ->
		@ressources.model[key] = model

		if typeof(model.is_loaded) == 'undefined' or model.is_loaded == false
			@queue.model++
			@ressources.model[key].fetch
				success: ->
					self = app.views.page
					self.data[key] = model.toJSON()
					self.queue.model--
					self.render()
		else
			@data[key] = model.toJSON()

	loadJSON: (key, obj)->
		@data[key] = obj

	loadTemplate: (template_id) ->
		@ressources.template = template_id
		@queue.template++
		app.template.loadTemplateHtml template_id, (response) ->
			self = app.views.page
			self.queue.template--
			self.render()

	callback: (callback) ->
		@queue.callback.push callback

	load: (page) ->
		$('body').addClass 'loading'

		if page.menu
			$('ul.menu li').removeClass 'active'
			$('ul.menu li[data-href='+page.menu+']').addClass 'active'

		@render()

	render: ->
		if @queue.template == 0 and @queue.model == 0 and @queue.collection == 0 
			console.log @data
			@$el.html app.template.render @ressources.template, @data
			$('body').removeClass 'loading'
			$('body').scrollTop 0

			$('input[type=textbox]').first().focus()

			callback() for callback in @queue.callback




