class OrdersController < ApplicationController
  include BreadExpressHelpers::Cart
  include BreadExpressHelpers::Shipping


  before_action :check_login
  before_action :set_order, only: [:show, :update, :destroy] #:new
  authorize_resource
  
  def index
    if logged_in? && !current_user.role?(:customer)
      @pending_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(15)
      @all_orders = Order.chronological.paginate(:page => params[:page]).per_page(15)
    else
      @pending_orders = current_user.customer.orders.not_shipped.chronological.paginate(:page => params[:page]).per_page(15)
      @all_orders = current_user.customer.orders.chronological.paginate(:page => params[:page]).per_page(15)
    end 
  end

  def show
    @order_items = @order.order_items.to_a
    if current_user.role?(:customer)
      @previous_orders = current_user.customer.orders.chronological.to_a
    else
      @previous_orders = @order.customer.orders.chronological.to_a
    end
  end

  def new
    @order = Order.new
  end

  def edit
    @order = Order.find(params[:id])
  end

  def create
    @order = Order.new(order_params)

    @order.credit_card_number = params[:order][:credit_card_number]
    @order.expiration_year = Date.parse(params[:order][:expiration_date]).year
    @order.expiration_month = Date.parse(params[:order][:expiration_date]).month

    @order.customer_id = current_user.customer.id
    @order.grand_total = calculate_cart_shipping + calculate_cart_items_cost
    @order.date = Date.today

    if @order.save
      save_each_item_in_cart(@order)

      @order.pay
      clear_cart
      redirect_to @order, notice: "Thank you for ordering from Bread Express."
    else
      flash[:alert] = "Invalid credit card info"
      render action: 'new'
    end
  end

  def update
    if @order.update(order_params)
      redirect_to @order, notice: "Your order was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: "This order was removed from the system."
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:address_id, credit_card_attributes: [:credit_card_number, :expiration_date])
  end

end