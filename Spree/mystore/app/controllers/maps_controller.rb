class MapsController < ApplicationController
  before_action :set_map, only: [:index]

  # GET /maps
  # GET /maps.json
  def index
    @prodEntregados = DataWarehouse::DeliveredProduct.all
    #where(client_id: file.rut, order_id: file.no_order, sku: orden.sku_order, address: direccion, quantitySent: response[1][:total] , deliveryDate: Date.current)
    @hash = Gmaps4rails.build_markers(@prodEntregados) do |prod, marker|
      marker.lat prod.latitude
      marker.lng prod.longitude
      marker.json({title: 'Pedido: ' + prod.order_id})
      #sumar más info en la infowindow!!!!!!******
      marker.json({infowindow: "<p>" + "Rut Cliente: " + prod.client_id + "<br />" + 
                  "Dirección: " + prod.address + "<br />" + "ID Pedido: " + prod.order_id + "<br />" + "Estado Pedido: " + prod.state.to_s + "%" +
                  "</p>"})
    end
  end

end