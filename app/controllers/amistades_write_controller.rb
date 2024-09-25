class AmistadesWriteController < ApplicationController
  def create
    # Extraer los parámetros
    cedula_persona1 = amistad_params[:cedula_persona1]
    cedula_persona2 = amistad_params[:cedula_persona2]

    # Crear una nueva amistad en la tabla de escritura
    @amistad_write = AmistadWrite.new(cedula_persona1, cedula_persona2)
    @amistad_write.save

    # Reflejar la creación en la tabla de lectura 'amistades'
    amistad_lectura = Amistad.new(cedula_persona1, cedula_persona2)
    amistad_lectura.save

    render json: { message: 'Amistad creada exitosamente' }, status: :created
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def update
    # Obtener los parámetros de la petición
    cedula_persona1 = amistad_params[:cedula_persona1]
    cedula_persona2 = amistad_params[:cedula_persona2]

    # Eliminar el registro anterior en Cassandra y guardar el actualizado
    AmistadWrite.delete_by_cedulas(cedula_persona1, cedula_persona2)

    # Crear una nueva amistad con los datos actualizados y guardarla
    @amistad_write = AmistadWrite.new(cedula_persona1, cedula_persona2)
    @amistad_write.save

    # Reflejar la actualización en la tabla de lectura 'amistades'
    amistad_lectura = Amistad.find_by_cedulas(cedula_persona1, cedula_persona2)
    if amistad_lectura
      amistad_lectura.update(cedula_persona1, cedula_persona2)
    else
      Amistad.new(cedula_persona1, cedula_persona2).save
    end

    render json: { message: 'Amistad actualizada exitosamente' }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def destroy
    # Obtener la cédula desde params[:id] (en la URL)
    cedula_persona1 = params[:id]

    # Obtener la segunda cédula desde el cuerpo de la solicitud (params)
    cedula_persona2 = params[:cedula_persona2]

    # Buscar y eliminar de la tabla de escritura
    @amistad_write = AmistadWrite.find_by_cedulas(cedula_persona1, cedula_persona2)
    if @amistad_write
      AmistadWrite.delete_by_cedulas(cedula_persona1, cedula_persona2)

      # También eliminar de la tabla de lectura 'amistades'
      Amistad.delete_by_cedulas(cedula_persona1, cedula_persona2)

      head :no_content
    else
      render json: { error: "Amistad no encontrada" }, status: :not_found
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def amistad_params
    # Permitir los parámetros de las dos cédulas
    params.require(:amistad).permit(:cedula_persona1, :cedula_persona2)
  end
end
