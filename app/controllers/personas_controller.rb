class PersonasController < ApplicationController
  def index
    @personas = Persona.all
    render json: @personas
  end

  def show
    @persona = Persona.find(params[:id])
    render json: @persona
  end

  def create
    @persona = Persona.new(persona_params)
    if @persona.save
      render json: @persona, status: :created
    else
      render json: @persona.errors, status: :unprocessable_entity
    end
  end

  def update
    @persona = Persona.find(params[:id])
    if @persona.update(persona_params)
      render json: @persona
    else
      render json: @persona.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @persona = Persona.find(params[:id])
    @persona.destroy
    head :no_content
  end

  private

  def persona_params
    params.require(:persona).permit(:cedula, :nombre)
  end
end
