class Warehouse4_api

 include HTTParty
 default_params output: 'json'
 format :json

  $user = "grupo1"
  password = "grupo1"
  $encryptedPassword = Digest::SHA1.hexdigest(password)

  def get_prod(sku, cantidad, almacen_id)
  	url =  "http://integra4.ing.puc.cl/api/pedirProducto"
	response = HTTParty.post(url,:body => { :usuario => $user, :password => $encryptedPassword, :almacen_id => almacen_id, :SKU => sku, :cantidad => cantidad })
	respjson = JSON.parse(response.body, symbolize_names: true)
	if !respjson.include?(:error)
		return respjson[:cantidad].to_i
	else 
		return -1
	end
	
  end

end