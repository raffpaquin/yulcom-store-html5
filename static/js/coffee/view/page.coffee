class Yulcom.View.Page extends Backbone.View

	el:'#content'
	ressources:
		template:null
		collection:{}
		model:{}
		sub_view:{}
		title:null

	queue:
		template:0
		collection:0
		model:0
		callback:[]

	data:{}
	action:{}


	reset: ->
		@data = {}
		@action = {}
		@ressources = 
			template:null
			collection:{}
			model:{}
			sub_view:{}
			title:null
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
			@render()

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
			@render()

	loadJSON: (key, obj)->
		@data[key] = obj

	loadTemplate: (template_id) ->
		@ressources.template = template_id
		@queue.template++
		app.template.loadTemplateHtml template_id, (response) ->
			self = app.views.page
			self.queue.template--
			self.render()

	loadSubView: (selector,template_id) ->
		@ressources.sub_view[template_id] =
			template:template_id
			selector:selector
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
		console.log @ressources.template, @queue.template, @queue.model, @queue.collection
		if @queue.template == 0 and @queue.model == 0 and @queue.collection == 0 

			$('#content').html app.template.render @ressources.template, @data

			self = @
			$.each @ressources.sub_view, (key, item) ->
				self.refreshSubView key

			$('body').removeClass 'loading'
			$('body').scrollTop 0

			$('input[type=textbox]').first().focus()

			if @ressources.title
				app.router._updateTitle app.template.renderFromStringTemplate @ressources.title, @data

			callback() for callback in @queue.callback

	title: (title) ->
		@ressources.title = title

	refreshModel: (key) ->
		@data[key] = @ressources.model[key].toJSON()

	refreshSubView: (key) ->
		item = @ressources.sub_view[key]
		if item
			$(item.selector).html app.template.render item.template, @data

	refreshCollection: (key) ->
		@data[key] = @ressources.collection[key].toJSON()



