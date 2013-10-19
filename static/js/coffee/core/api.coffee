app.api = 
	defaults:
		url:'http://local.api.yulcom.ca/v1.0/terminal/'
	post: (obj) ->
		
		if obj.data
			if typeof(obj.data) == 'string'
				obj.data = @stringToJson obj.data

		#default Values
		obj.url = @defaults.url+obj.url
		obj.dataType = 'json'

		#Progress bar

		obj.beforeSend = (xhr) ->
			$('#progress').stop()
			$('#progress').animate 
				width:'0%'
			,0
			if app.models.customer.credentials[0] && app.models.customer.credentials[1]
				xhr.setRequestHeader 'Authorization', 'Basic ' + window.btoa(app.models.customer.credentials.join(':'))

		obj.xhr = ->
			xhr = $.ajaxSettings.xhr()
			if xhr instanceof window.XMLHttpRequest
				if xhr.upload
					xhr.upload.addEventListener 'progress', (evt) ->
						if evt.lengthComputable
							percentComplete = evt.loaded / evt.total * 100
							$('#progress').animate 
								width:percentage+'%'
							,200
					,false
				
				xhr.addEventListener 'progress', (evt) ->
					if evt.lengthComputable
						percentComplete = evt.loaded / evt.total * 100
				,false

			
			xhr  

		obj.complete = () ->
			$('#progress').stop()
			$('#progress').animate 
				width:'100%'
			,300
		
		$.ajax obj

		true

	stringToJson: (string) ->
		JSON.parse '{"' + decodeURIComponent(string).replace(/"/g, '\\"').replace(/&/g, '","').replace(/\=/g,'":"') + '"}'