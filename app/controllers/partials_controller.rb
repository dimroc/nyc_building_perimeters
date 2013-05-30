class PartialsController < ApplicationController
  def show
    render partial: "partials/#{params[:id]}"
  end
end
