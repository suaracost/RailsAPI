class AmistadesController < ApplicationController
  def index
    # Obtener todas las amistades desde Cassandra
    @amistades = Amistad.all
    render json: @amistades
  end

  def show
    # Buscar una amistad por cédula (reemplazar con el campo correcto)
    cedula_persona1 = params[:cedula_persona1]
    cedula_persona2 = params[:cedula_persona2]

    @amistad = Amistad.find_by_cedulas(cedula_persona1, cedula_persona2)
    if @amistad
      render json: @amistad
    else
      render json: { error: 'Amistad no encontrada' }, status: :not_found
    end
  end
end
