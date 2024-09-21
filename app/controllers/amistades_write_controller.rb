class AmistadesWriteController < ApplicationController
  def create
    @amistad_write = AmistadWrite.new(amistad_params)
    if @amistad_write.save
      # Refleja la creación en la tabla de lectura 'amistades'
      Amistad.create(cedula_persona1: @amistad_write.cedula_persona1, cedula_persona2: @amistad_write.cedula_persona2)
      render json: @amistad_write, status: :created
    else
      render json: @amistad_write.errors, status: :unprocessable_entity
    end
  end

  def update
    @amistad_write = AmistadWrite.find(params[:id])
    if @amistad_write.update(amistad_params)
      # Refleja la actualización en la tabla de lectura 'amistades'
      amistad_lectura = Amistad.find_by(params[:id])
      if amistad_lectura
        amistad_lectura.update(cedula_persona1: @amistad_write.cedula_persona1, cedula_persona2: @amistad_write.cedula_persona2)
      end
      render json: @amistad_write
    else
      render json: @amistad_write.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @amistad_write = AmistadWrite.find(params[:id])
    if @amistad_write
      # Elimina de la tabla de lectura 'amistades'
      Amistad.where(cedula_persona1: @amistad_write.cedula_persona1, cedula_persona2: @amistad_write.cedula_persona2).destroy_all
      @amistad_write.destroy
      head :no_content
    else
      render json: { error: "Amistad no encontrada" }, status: :not_found
    end
  end

  private

  def amistad_params
    params.require(:amistad).permit(:cedula_persona1, :cedula_persona2)
  end
end
