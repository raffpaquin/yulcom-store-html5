class Yulcom.Collection.Cc extends Yulcom.Collection.Base
	model: Yulcom.Model.CustomerCc 
	url: ->
		app.get('api')+'customer/cc/list'