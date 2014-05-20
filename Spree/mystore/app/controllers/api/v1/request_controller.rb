module Api
  module V1
    class RequestController < ApplicationController

      # POST /pedirProducto
      def create
        @resultado = Request.pedirProducto(params[:usuario], params[:password], params[:almacenId], params[:sku], params[:cant])
        render json: @resultado

      end
 
    end
  end
end 