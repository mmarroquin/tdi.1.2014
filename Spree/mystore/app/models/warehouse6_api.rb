class Warehouse6_api

 include HTTParty
 default_params output: 'json'
 format :json

  @@user = "grupo1"
  @@password = "1"

  def get_prod(sku, cantidad, almacen_id)
  	begin
  	respjson = request(sku,cantidad,almacen_id)
	  if !respjson[0].include?(:error) && respjson[0].include?(:cantidad)
		  return respjson[0][:cantidad].to_i
	  else 
		  return -1
	  end
	rescue
      return -1
    end
	
  end

  def request(sku, cantidad, almacen_id)
  	url =  "http://integra6.ing.puc.cl/apiGrupo/pedido"
	  response = HTTParty.post(url,:body => { :usuario => @@user, :password => @@password, :almacen_id => almacen_id, :SKU => sku, :cantidad => cantidad })
	  return JSON.parse(response.body, symbolize_names: true)
  end

end