module Customers
  class OrdersController < AuthenticatedController
    # default wrapping behavior (i.e., copying some root params to model-keyed param) excludes the association_ids=
    # method ActiveRecord provides. We want this to easily and cleanly set meals on the order on create.
    wrap_parameters :order, include: Order.attribute_names + [:meal_ids]
    before_action :set_order, only: %i[ show update ]

    def index
      @orders = Order.accessible_by(current_ability)
    end

    def show
      authorize! :show, @order
    end

    def create
      # meal_ids included here is sufficient for creating the join rown (also true in #update, for creating/deleting rows)
      @order = Order.new(order_params.merge(user_id: current_user.id))
      authorize! :create, @order

      @order.order_statuses.build(status: 'placed')

      if @order.save
        render :show, status: :created
      else
        render json: @order.errors, status: :unprocessable_entity
      end
    end

    def update
      authorize! :update, @order

      if @order.update(order_params)
        render :show, status: :ok
      else
        render json: @order.errors, status: :unprocessable_entity
      end
    end


    private
      def set_order
        @order = Order.find(params[:id])
      end

      def order_params
        params.require(:order).permit(:restaurant_id, meal_ids: [])
      end
  end
end
