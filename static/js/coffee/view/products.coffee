ViewPageProduct = ViewPage.extend

	

	loadProductCollection: ->
		app.collections.products.fetch()