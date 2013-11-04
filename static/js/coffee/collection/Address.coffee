class Yulcom.Collection.Address extends Yulcom.Collection.Base
	model: Yulcom.Model.CustomerAddress 
	url: ->
		app.get('api')+'customer/address/list'
