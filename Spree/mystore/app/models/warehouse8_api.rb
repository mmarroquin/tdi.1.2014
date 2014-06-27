class Warehouse8_api

 include HTTParty
 default_params output: 'json'
 format :json

  @@user = "grupo1"
  password = "grupo1"
  @@encryptedPassword = Digest::SHA1.hexdigest(password)

  def get_prod(sku, cantidad, almacen_id)
	begin
	response = request(sku, cantidad, almacen_id)
	if !response[0].include?("error") && response[0].include?("cantidad")
		return response[0]["cantidad"].to_i
	else 
		return -1
	end
	rescue
      return -1
    end
	
  end

  def request(sku, cantidad, almacen_id)
  	url =  "http://integra8.ing.puc.cl/api/pedirProducto"
	return HTTParty.post(url,:body => { :usuario => @@user, :password => @@encryptedPassword, :almacen_id => almacen_id, :SKU => sku, :cantidad => cantidad })
  end

end