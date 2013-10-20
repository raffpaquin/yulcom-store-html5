CollectionProduct = Backbone.Collection.extend
	model: app.models.product
	url: app.get('api')+'catalog/product/list' 

	parse: (response) ->
		return _.map response.data.items, (obj) ->
			obj.id = obj._id.$id
			delete obj._id
			delete obj._
			return obj