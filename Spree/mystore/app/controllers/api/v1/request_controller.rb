class Api::V1::RequestController < ApplicationController

  skip_before_action :verify_authenticity_token

  @@permisos = {"grupo1" => "grupo1", "grupo2" => "qwertyuiop", "grupo3" => "grupo3", "grupo4" => "373f3f314f442d67ec9512e24b82d550e72a2ec3", "grupo5" => "grupo5", "grupo6" => "ebdf1bdb858ced98b4adef024c3ec86fbdc141c9", "grupo7" => "grupo7", "grupo8" => "grupo8", "grupo9" => "QWhiPGn2Hnm54"}
  # POST /api/v1/pedirProducto
  def create
    if params[:password] == @@permisos[params[:usuario]]
    @resultado = Request.pedirProducto(params[:sku], params[:cant], params[:almacenId])
    render json: @resultado
    else
    render json: {:error => "Usuario o password incorrecto"}
    end
  end

end 