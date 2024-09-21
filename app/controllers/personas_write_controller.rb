class PersonasWriteController < ApplicationController
  def create
    @persona = Persona.new(persona_params)
    if @persona.save
      # Copia la información en la tabla de lectura (que es también 'personas')
      Persona.create(cedula: @persona.cedula, nombre: @persona.nombre)
      render json: @persona, status: :created
    else
      render json: @persona.errors, status: :unprocessable_entity
    end
  end

  def update
    @persona = Persona.find(params[:id])
    if @persona.update(persona_params)
      # Actualiza también en la tabla de lectura
      persona = Persona.find_by(cedula: @persona.cedula)
      persona.update(nombre: @persona.nombre)
      render json: @persona
    else
      render json: @persona.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @persona = Persona.find(params[:id])
    @persona.destroy

    # También elimina de la tabla de lectura
    Persona.where(cedula: @persona.cedula).destroy_all

    head :no_content
  end

  private

  def persona_params
    params.require(:persona).permit(:cedula, :nombre)
  end
end
