$ ->

	$('body').on 'click', '[data-action]', (event) ->

		$this = $ this
		attr = $this.attr("data-action").split '|'
		action = attr[0]
		scope = if attr[1]? then attr[1] else "body"

		if !action or action == ''	
			return false

		app.views.menu.nav.destroy()


		app.trigger action,
			scope:scope
			cta:this

		event.preventDefault()

		false
