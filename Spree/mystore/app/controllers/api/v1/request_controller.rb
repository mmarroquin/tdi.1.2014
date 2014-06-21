class Api::V1::RequestsController < ApplicationController

  $permisos = {"grupo9" => "QWhiPGn2Hnm54", "grupo6" => "ebdf1bdb858ced98b4adef024c3ec86fbdc141c9", "Grupo2" => "qwertyiop"}
  # POST /api/v1/pedirProducto
  def create
    if params[:password] == permisos[params[:usuario]]
    @resultado = Request.pedirProducto(params[:almacenId], params[:sku], params[:cant])
    render json: @resultado
    else
    render json: {:error => "Usuario o password incorrecto"}
    end
  end

end 