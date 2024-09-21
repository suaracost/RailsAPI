class PersonasController < ApplicationController
  def index
    @personas = Persona.all
    render json: @personas
  end

  def show
    @persona = Persona.find(params[:id])
    render json: @persona
  end
end
