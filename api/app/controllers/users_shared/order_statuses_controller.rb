module UsersShared
  class OrderStatusesController < AuthenticatedController
    before_action :set_order

    def index
      @order_statuses = OrderStatus.accessible_by(current_ability).order_by_desc_recency
    end

    def create
      @order_status = @order.order_statuses.new(order_status_params)
      authorize! :create, @order_status

      if @order_status.valid_for_user?(current_user) && @order_status.save
        render :show, status: :created
      else
        render json: @order_status.errors, status: :unprocessable_entity
      end
    end


    private
      def set_order
        @order = Order.find(params[:order_id])
      end

      def order_status_params
        params.require(:order_status).permit(:status)
      end
  end
end
