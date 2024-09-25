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

  def index
    # Obtener todas las personas desde Cassandra
    @personas = Persona.all
    render json: @personas
  end

  def show
    # Usar el método find_by_cedula para buscar por cédula
    cedula = params[:id]
    @persona = Persona.find_by_cedula(cedula)

    if @persona
      render json: @persona
    else
      render json: { error: "Persona no encontrada" }, status: :not_found
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def update
    # Extraer la cédula de los parámetros de la URL y el nuevo nombre del cuerpo de la solicitud
    cedula = params[:id]  # La cédula se encuentra en el parámetro :id de la URL
    nombre = persona_params[:nombre]  # El nombre nuevo viene en el cuerpo de la solicitud

    # Eliminamos el registro anterior por cédula (debe ser un método de clase)
    PersonaWrite.delete_by_cedula(cedula)

    # Crear una nueva instancia con los datos actualizados y guardarla
    @persona_write = PersonaWrite.new(cedula, nombre)
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
    # Obtener la cédula desde params[:id] en lugar de params[:cedula]
    cedula = params[:id]

    # Buscar la persona en la tabla de escritura y eliminarla
    @persona_write = PersonaWrite.find_by_cedula(cedula)
    if @persona_write
      PersonaWrite.delete_by_cedula(cedula)
      
      # Eliminar también de la tabla de lectura 'persona'
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
    # Asegúrate de permitir el parámetro :cedula
    params.require(:persona).permit(:cedula, :nombre)
  end
end
