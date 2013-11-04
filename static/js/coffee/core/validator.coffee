app.validation =
	email: (email) ->
		email.match(/^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/)?

	name: (name) ->
		name.length >= 2

	password: (password) ->
		#password.match(/^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{6,16}$/)?
		password.match(/^[a-zA-Z0-9!@#$%^&*]{6,16}$/)?

	egals: (str1, str2) ->
		str1 == str2
