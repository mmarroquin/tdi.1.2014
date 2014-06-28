class MapsController < ApplicationController
  before_action :set_map, only: [:index]

  # GET /maps
  # GET /maps.json
  def index
    @prodEntregados = DataWarehouse::DeliveredProduct.limit(30).map{ |order|  [order.order_id, order.client_id, order.address, order.coordinates].flatten }
    #where(client_id: file.rut, order_id: file.no_order, sku: orden.sku_order, address: direccion, quantitySent: response[1][:total] , deliveryDate: Date.current)
    @hash = Gmaps4rails.build_markers(@prodEntregados) do |prod, marker|
      marker.lat prod[3]
      marker.lng prod[4]
      marker.json({title: 'Pedido: ' + prod[0]})
      #sumar más info en la infowindow!!!!!!******
      marker.json({infowindow: "<p>" + "Rut Cliente: " + prod[1] + "<br />" + 
                  "Dirección: " + prod[2] + "<br />" + "ID Pedido: " + prod[0] + "<br />" +
                  "</p>"})
    end
  end

end