module Owners
  class RestaurantsController < AuthenticatedController
    before_action :set_restaurant, only: %i[ show update ]

    def index
      @restaurants = Restaurant.accessible_by(current_ability)
    end

    def show
      authorize! :show, @restaurant
    end

    def update
      authorize! :update, @restaurant

      if @restaurant.update(@restaurant_params)
        render :show, status: :ok
      else
        render json: @restaurant.errors, status: :unprocessable_entity
      end
    end

    private
      def set_restaurant
        @restaurant = Restaurant.find(params[:id])
      end

      def restaurant_params
        params.require(:restaurant).permit(:name, :description)
      end
  end
end
