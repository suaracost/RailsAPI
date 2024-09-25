class PersonasWriteController < ApplicationController
  def create
    # Extraemos los parámetros
    cedula = persona_params[:cedula]
    nombre = persona_params[:nombre]

    # Creamos una nueva instancia de PersonaWrite y la guardamos en Cassandra
    @persona_write = PersonaWrite.new(cedula, nombre)
    @persona_write.save

    # Reflejamos la creación en la tabla de lectura 'persona'
    persona_lectura = Persona.new(cedula, nombre)
    persona_lectura.save

    render json: { message: 'Persona creada exitosamente' }, status: :created
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def update
    # Aquí podrías necesitar hacer una búsqueda manual según cómo esté estructurada tu tabla
    # Actualizamos en la tabla persona_write
    cedula = persona_params[:cedula]
    nombre = persona_params[:nombre]

    @persona_write = PersonaWrite.new(cedula, nombre)
    
    # Eliminamos el registro anterior y guardamos el actualizado
    @persona_write.delete_by_cedula(cedula)
    @persona_write.save

    # Reflejamos la actualización en la tabla de lectura 'persona'
    persona_lectura = Persona.find_by_cedula(cedula)
    if persona_lectura
      persona_lectura.update(nombre)
    else
      Persona.new(cedula, nombre).save
    end

    render json: { message: 'Persona actualizada exitosamente' }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def destroy
    # Eliminar de la tabla de escritura y lectura
    cedula = params[:cedula]

    @persona_write = PersonaWrite.find_by_cedula(cedula)
    if @persona_write
      @persona_write.delete_by_cedula(cedula)
      
      # Eliminamos también de la tabla de lectura
      Persona.delete_by_cedula(cedula)

      head :no_content
    else
      render json: { error: "Persona no encontrada" }, status: :not_found
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def persona_params
    params.require(:persona).permit(:cedula, :nombre)
  end
end
