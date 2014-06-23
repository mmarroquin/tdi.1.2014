class Warehouse1_api

 include HTTParty
 default_params output: 'json'
 format :json

  $user = "grupo1"
  $password = "grupo1"


  def get_prod(sku, cantidad, almacen_id)
	begin
	response = request(sku, cantidad, almacen_id)
	if !response.include?("error") && response.include?("cantidad")
		return response["amountSent"]
	else 
		return response["error"]
	end
	rescue
      return -1
    end
	
  end

  def request(sku, cantidad, almacen_id)
  	url =  "http://integra1.ing.puc.cl/ecommerce/api/v1/pedirProducto"
	return HTTParty.post(url,:body => { :usuario => $user, :password => $password, :almacenId => almacen_id, :sku => sku, :cant => cantidad })
  end

end