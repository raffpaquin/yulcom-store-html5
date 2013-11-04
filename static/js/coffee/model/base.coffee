class Yulcom.Model.Base extends Backbone.Model
	@is_loaded:false
	###fetch: (obj = {}) ->
		if app.customer.isLogin()
			obj.beforeSend = (xhr) ->
				xhr.setRequestHeader('Authorization', 'Basic ' + window.btoa(app.customer.get('session_key')+':'+app.customer.get('session_password')))
		super obj ###

	parse: (response) ->
		if response.data
			response.data
		else
			response
