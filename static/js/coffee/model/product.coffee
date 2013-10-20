app.models.product = Backbone.Model.extend
	url: ->
		app.get('api')+'catalog/product/'+@id+'/details'
			
	parse: (response) ->
		if response.data
			response.data
		else
			response