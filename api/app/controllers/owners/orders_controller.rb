module Owners
  class OrdersController < AuthenticatedController
    before_action :set_restaurant
    before_action :set_order, only: :show

    def index
      @orders = Order.accessible_by(current_ability)
    end

    def show
      authorize! :show, @order
    end

    private
      def set_order
        @order = Order.find(params[:id])
      end

      def set_restaurant
        @restaurant = Restaurant.find(params[:restaurant_id])
      end

      def order_params
        params.require(:order).permit(:order_date, :total_in_cents)
      end
  end
end

