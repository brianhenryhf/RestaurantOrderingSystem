module Owners
  class MealsController < AuthenticatedController
    before_action :set_restaurant
    before_action :set_meal, only: %i[ show update ]

    def index
      @meals = Meal.accessible_by(current_ability)
    end

    def show
      authorize! :show, @meal
    end

    def create
      @meal = @restaurant.meals.new(meal_params)
      authorize! :create, @meal

      if @meal.save
        render :show, status: :created
      else
        render json: meal.errors, status: :unprocessable_entity
      end
    end

    def update
      authorize! :update, @meal

      if @meal.update(meal_params)
        render :show, status: :ok
      else
        render json: @meal.errors, status: :unprocessable_entity
      end
    end

    private
      def set_meal
        @meal = Meal.find(params[:id])
      end

      def set_restaurant
        @restaurant = Restaurant.find(params[:restaurant_id])
      end

      def meal_params
        params.require(:meal).permit(:name, :description, :price_in_cents)
      end
  end
end
