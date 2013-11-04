app.api = 
	post: (obj) ->
		
		if obj.data
			if typeof(obj.data) == 'string'
				obj.data = @stringToJson obj.data

		#default Values
		obj.url = app.get('api')+obj.url
		obj.dataType = 'json'

		#if app.customer.isLogin()
		#	obj.username = app.customer.get 'session_key'
		#	obj.password = app.customer.get 'session_password'

		#console.log obj

		if app.customer.isLogin()
			obj.beforeSend = (xhr) ->
				xhr.setRequestHeader('Authorization', 'Basic ' + window.btoa(app.customer.get('session_key')+':'+app.customer.get('session_password')))
		
		$.ajax obj

		true

	stringToJson: (string) ->
		JSON.parse '{"' + decodeURIComponent(string).replace(/"/g, '\\"').replace(/&/g, '","').replace(/\=/g,'":"') + '"}'