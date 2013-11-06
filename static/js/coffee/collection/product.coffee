class Yulcom.Collection.Product extends Yulcom.Collection.Base
	model: app.models.product
	url: app.get('api')+'catalog/product/list' 

	parse: (response) ->
		@is_loaded = true
		return _.map response.data.items, (obj) ->
			delete obj._
			return obj