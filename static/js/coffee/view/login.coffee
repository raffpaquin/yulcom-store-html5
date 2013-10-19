PageView = Backbone.View.extend
	el: $('#content')

	render: () ->
		sg = @
		@el.fadeOut 'fast', ->
			sg.el.empty()
			$.tmpl(sg.indexTemplate, sg.model.toArray()).appendTo(sg.el)
			sg.el.fadeIn 'fast'
		@