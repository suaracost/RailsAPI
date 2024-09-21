class AmistadesController < ApplicationController
  def index
    @amistades = Amistad.all
    render json: @amistades
  end

  def show
    @amistades = Amistad.where(cedula_persona1: params[:id])
    render json: @amistades
  end

  def create
    @amistad = Amistad.new(amistad_params)
    if @amistad.save
      render json: @amistad, status: :created
    else
      render json: @amistad.errors, status: :unprocessable_entity
    end
  end

  def update
    @amistad = Amistad.find(params[:id])
    if @amistad.update(amistad_params)
      render json: @amistad
    else
      render json: @amistad.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @amistad = Amistad.find(params[:id])
    @amistad.destroy
    head :no_content
  end

  private

  def amistad_params
    params.require(:amistad).permit(:cedula_persona1, :cedula_persona2)
  end
end
