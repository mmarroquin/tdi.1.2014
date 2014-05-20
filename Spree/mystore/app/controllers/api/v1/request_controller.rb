module Api
  module V1
    class RequestController < ApplicationController
    	@@permisos = {:grupoX => "QWhiPGn2Hnm54", :grupoY => "PnBiPHn2H4l5D", :grupoZ => "Gahi34n2H8mSj"}]
      # POST /pedirProducto
      def create
      	if params[:password] == permisos[params[:usuario]]
        @resultado = Request.pedirProducto(params[:almacenId], params[:sku], params[:cant])
        render json: @resultado
    	else
    		error = { :error => "Usuario o password incorrecto"}
    		render json: error
    	end
      end
 
    end
  end
end 