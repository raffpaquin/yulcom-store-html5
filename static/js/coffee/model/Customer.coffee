class Yulcom.Model.Customer extends Backbone.Model

	defaults:
		is_login:false
		session_key:false
		session_password:false

	init: ->
		k = app.cookie.read 'ycsk'
		p = app.cookie.read 'ycsd'

		if false == k or false == p or 'false' == k or 'false' == p
			return

		@login.saveSessionInfo k,p,{}
		

	isLogin: ->
		@get 'is_login'

	logout: ->
		app.cookie.write 'ycsk', false
		app.cookie.write 'ycsd', false

		app.customer.set 'session_key', false
		app.customer.set 'session_password', false
		app.customer.set 'customer_details',  {}
		app.customer.set 'is_login', false

	login:
		saveEmail: ->
			email = $('.login-step1 input[name=email]').val()
			app.load true, '.login-box'
			if app.validation.email email
				
				$('.login-box .login-step1').fadeOut 200, ->
					$('.login-box .login-step2').fadeIn 200
					$('.login-step2 input[type=textbox]').first().focus()
					app.load false
			else
				app.error 'Invalid Email Address', '.login-box'
				$('.login-step1 input[type=textbox]').first().focus()
				app.load false, '.login-box'

		savePassword: ->
			app.load true, '.login-box'

			email = $('.login-step1 input[name=email]').val()
			firstname = $('.login-step2 input[name=firstname]').val()
			lastname = $('.login-step2 input[name=lastname]').val()
			password = $('.login-step2 input[name=password]').val()
			password2 = $('.login-step2 input[name=password2]').val()

			if not app.validation.name firstname
				app.error 'Please enter a valid firstname', '.login-box'
				$('.login-step2 input[name=firstname]').first().focus()
				app.load false
				return

			if not app.validation.name lastname
				app.error 'Please enter a valid lastname', '.login-box'
				$('.login-step2 input[name=lastname]').first().focus()
				app.load false
				return

			if not app.validation.password password
				app.error 'Password must be between 6 and 16 characters', '.login-box'
				$('.login-step2 input[name=password]').first().focus()
				app.load false
				return

			if not app.validation.egals password, password2
				app.error 'Both password must match', '.login-box'
				$('.login-step2 input[name=password2]').first().focus()
				app.load false
				return


			app.api.post
				url:'customer/signup'
				data:
					email:email
					password:password
					details:
						firstname:firstname
						lastname:lastname


				success: (response) ->
					app.load false
					if response.status == 'success'
						app.customer.login.saveSessionInfo response.data.session_id, response.data.session_key, response.data.customer_details
						$('.login-box .login-step2').fadeOut 200, ->
							$('.login-box .login-step4').fadeIn 200
					else
						app.error response.message
				error: (response) ->
					app.error 'Unknow server error'
					app.load false



		showLogin: ->
			app.load true, '.login-box'
			$('.login-box .login-step1').fadeOut 200, ->
				$('.login-box .login-step3').fadeIn 200
				$('.login-step3 input[type=textbox]').first().focus()
				app.load false

		showAccountCreation: ->
			app.load true, '.login-box'
			$('.login-box .login-step3').fadeOut 200, ->
				$('.login-box .login-step1').fadeIn 200
				$('.login-step1 input[type=textbox]').first().focus()
				app.load false

		saveSessionInfo: (k,p,d) ->
			app.customer.set 'session_key', k
			app.customer.set 'session_password', p
			app.customer.set 'customer_details', d
			app.customer.set 'is_login', true

			app.cookie.write 'ycsk', k
			app.cookie.write 'ycsd', p

			$.ajaxSetup
				headers:
					'Authorization':'Basic ' + window.btoa(k+':'+p)



		login: ->
			app.load true, '.login-box'

			email = $('.login-step3 input[name=email]').val()
			password = $('.login-step3 input[name=password]').val()

			if not app.validation.name email
				app.error 'Please enter an email address', '.login-box'
				$('.login-step3 input[name=email]').first().focus()
				app.load false
				return

			if not app.validation.name password
				app.error 'Please enter a  pasword', '.login-box'
				$('.login-step3 input[name=password]').first().focus()
				app.load false
				return


			app.api.post
				url:'customer/session'
				type:'POST'
				data:
					email:email
					password:password
				success: (response) ->
					app.load false
					if response.status == 'success'
						app.customer.login.saveSessionInfo response.data.session_id, response.data.session_key, response.data.customer_details
						$('.login-box .login-step3').fadeOut 200, ->
							$('.login-box .login-step3').fadeIn 200
					else
						app.error response.message
				error: (response) ->
					app.error 'Unknow server error'
					app.load false


