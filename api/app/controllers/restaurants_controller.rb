# Note that `current_user` is valid here in unauthed context, but may be nil
class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: %i[ show ]

  def index
    @restaurants = Restaurant.all
    authorize! :public_read, Restaurant
  end

  def show
    authorize! :public_read, @restaurant
  end

  private
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    # May have future use for simple restaurant search filters
    # def restaurant_params
    #   params.require(:restaurant).permit(:name, :description)
    # end
end
