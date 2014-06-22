class W1api

 include HTTParty
 default_params output: 'json'
 format :json

  $user = "grupo9"
  $password = "QWhiPGn2Hnm54"

  def get_prod(sku, cantidad, almacen_id)
  	url =  "http://integra1.ing.puc.cl/ecommerce/api/v1/pedirProducto"
	response = HTTParty.post(url,:body => { :usuario => $user, :password => $password, :almacenId => almacen_id, :sku => sku, :cant => cantidad })
	return JSON.parse(response.body, symbolize_names: true)
	if !response.include?(:error)
		return response[:amountSent]
	else 
		return -1
	end
	
  end

end