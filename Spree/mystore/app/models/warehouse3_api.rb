class Warehouse3_api

 include HTTParty
 default_params output: 'json'
 format :json

  $user = "grupo1"
  $password = "grupo1"

  def get_prod(sku, cantidad, almacen_id)
  	respjson = request(sku,cantidad,almacen_id)
	if !respjson.include?(:error)
		return respjson[:cantidad].to_i
	else 
		return -1
	end
	
  end

  def request(sku, cantidad, almacen_id)
  	url =  "http://integra3.ing.puc.cl/api/pedirProducto"
	return response = HTTParty.post(url,:body => { :usuario => $user, :password => $password, :almacen_id => almacen_id, :SKU => sku, :cantidad => cantidad })
  end

end