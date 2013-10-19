$ ->
	app.on 'all', app.analytics.trackEvent
	app.controller.on 'all', app.analytics.trackPageView
	#app.collections.cart.on 'all', app.analytics.trackEvent

app.analytics =
	trackEvent: (key) ->
		#window.dataLayer.push({'event':'pageview','pageview': '/event/'+key})

	trackPageView: (key) ->
		#if key != 'route'
			#window.dataLayer.push({'event':'pageview','pageview': '/'+key})