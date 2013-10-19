app.validator =
	validateSizes: (params) ->
		#We have sizes?
		$sizes = $('.btn-size a' ,params.scope)
		if $sizes.length > 0
			$size_selected = $('.btn-size a.active' ,params.scope)
			if $size_selected.length <= 0
				$('.alert' ,params.scope).first().text('Please select a size').show 0
				return false
			else
				$('.alert' ,params.scope).first().text('').hide 0
		return true 
