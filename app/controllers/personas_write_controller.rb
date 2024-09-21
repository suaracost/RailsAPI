class PersonasWriteController < ApplicationController
  def create
    @persona_write = PersonaWrite.new(persona_params)
    if @persona_write.save
      # Refleja la creación en la tabla de lectura 'personas'
      Persona.create(cedula: @persona_write.cedula, nombre: @persona_write.nombre)
      render json: @persona_write, status: :created
    else
      render json: @persona_write.errors, status: :unprocessable_entity
    end
  end

  def update
    @persona_write = PersonaWrite.find(params[:id])
    if @persona_write.update(persona_params)
      # Refleja la actualización en la tabla de lectura 'personas'
      persona_lectura = Persona.find_by(cedula: @persona_write.cedula)
      if persona_lectura
        persona_lectura.update(nombre: @persona_write.nombre)
      else
        Persona.create(cedula: @persona_write.cedula, nombre: @persona_write.nombre)
      end
      render json: @persona_write
    else
      render json: @persona_write.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @persona_write = PersonaWrite.find(params[:id])
    if @persona_write
      # Elimina de la tabla de lectura 'personas'
      Persona.where(cedula: @persona_write.cedula).destroy_all
      @persona_write.destroy
      head :no_content
    else
      render json: { error: "Persona no encontrada" }, status: :not_found
    end
  end

  private

  def persona_params
    params.require(:persona).permit(:cedula, :nombre)
  end
end
