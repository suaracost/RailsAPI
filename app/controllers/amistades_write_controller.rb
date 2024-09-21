class AmistadesWriteController < ApplicationController
  def create
    @amistad = AmistadWrite.new(amistad_params)
    if @amistad.save
      # Copia la información en la tabla de lectura (que es también 'amistades')
      Amistad.create(cedula_persona1: @amistad.cedula_persona1, cedula_persona2: @amistad.cedula_persona2)
      render json: @amistad, status: :created
    else
      render json: @amistad.errors, status: :unprocessable_entity
    end
  end

  def update
    @amistad = AmistadWrite.find(params[:id])
    if @amistad.update(amistad_params)
      # Actualiza también en la tabla de lectura
      amistad = Amistad.find_by(cedula_persona1: @amistad.cedula_persona1, cedula_persona2: @amistad.cedula_persona2)
      amistad.update(cedula_persona1: @amistad.cedula_persona1, cedula_persona2: @amistad.cedula_persona2)
      render json: @amistad
    else
      render json: @amistad.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @amistad = AmistadWrite.find(params[:id])
    @amistad.destroy

    # También elimina de la tabla de lectura
    Amistad.where(cedula_persona1: @amistad.cedula_persona1, cedula_persona2: @amistad.cedula_persona2).destroy_all

    head :no_content
  end

  private

  def amistad_params
    params.require(:amistad).permit(:cedula_persona1, :cedula_persona2)
  end
end
