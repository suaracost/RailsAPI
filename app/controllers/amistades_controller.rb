class AmistadesController < ApplicationController
  def index
    @amistades = Amistad.all
    render json: @amistades
  end

  def show
    @amistad = Amistad.find(params[:id])
    render json: @amistad
  end
end
