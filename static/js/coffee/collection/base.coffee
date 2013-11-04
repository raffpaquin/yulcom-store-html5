class Yulcom.Collection.Base extends Backbone.Collection
	is_loaded:false
	parse: (response) ->
		@is_loaded = true
		if response.data.items
			response.data.items
		else
			response.data

	###fetch: (obj = {}) ->
		if app.customer.isLogin()
			obj.beforeSend = (xhr) ->
				xhr.setRequestHeader('Authorization', 'Basic ' + window.btoa(app.customer.get('session_key')+':'+app.customer.get('session_password')))
		
		super obj###
