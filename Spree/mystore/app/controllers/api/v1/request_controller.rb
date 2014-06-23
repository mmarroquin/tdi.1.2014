class Api::V1::RequestController < ApplicationController

  skip_before_action :verify_authenticity_token

  $permisos = {"grupo3" => "grupo3", "grupo9" => "QWhiPGn2Hnm54", "grupo4" => "grupo4integra", "grupo6" => "ebdf1bdb858ced98b4adef024c3ec86fbdc141c9", "grupo2" => "qwertyuiop"}
  # POST /api/v1/pedirProducto
  def create
    if params[:password] == $permisos[params[:usuario]]
    @resultado = Request.pedirProducto(params[:almacenId], params[:sku], params[:cant])
    render json: @resultado
    else
    render json: {:error => "Usuario o password incorrecto"}
    end
  end

end 