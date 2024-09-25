class PersonasController < ApplicationController
  def index
    # Obtener todas las personas desde Cassandra
    @personas = Persona.all
    render json: @personas
  end

  def show
    # Buscar una persona por cédula utilizando el parámetro 'id' de la URL
    cedula = params[:id]  # Captura el parámetro 'id' desde la URL
    @persona = Persona.find_by_cedula(cedula)  # Usar el método 'find_by_cedula'

    if @persona
      render json: @persona
    else
      render json: { error: "Persona no encontrada" }, status: :not_found
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
