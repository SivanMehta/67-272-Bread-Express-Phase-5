class CustomersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  include BreadExpressHelpers::Cart
  
  before_action :check_login, except: [:new, :create]
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  authorize_resource
  
  def index
    @active_customers = Customer.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_customers = Customer.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @previous_orders = @customer.orders.chronological
  end

  def new
    @customer = Customer.new
    @customer.user = User.new
  end

  def edit
    # reformat phone w/ dashes when displayed for editing (preference; not required)
    @customer.phone = number_to_phone(@customer.phone)
    # should have a user associated with customer, but just in case...
  end

  def create
    @customer = Customer.new(customer_params)
    @customer.user = User.new(customer_params[:user_attributes])
    if @customer.save and @customer.user.save
      current_user = @customer.user
      session[:user_id] = @customer.user.id
      create_cart
      redirect_to @customer, notice: "#{@customer.proper_name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    # just in case customer trying to hack the http request...
    reset_username_param unless current_user.role? :admin
    if @customer.update(customer_params)
      redirect_to @customer, notice: "#{@customer.proper_name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @customer.active = false
    @customer.save!
    redirect_to customers_url
  end

  private
  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    reset_role_param unless current_user && current_user.role?(:admin)
    params.require(:customer).permit(:first_name, :last_name, :email, :phone, :active, user_attributes: [:username, :password, :password_confirmation, :role, :id] )
  end

  def reset_role_param
    # unless current_user.role? :customer
      params[:customer][:user_attributes][:role] = "customer"
    # end
  end

  def reset_username_param
    unless current_user.role? :customer
      params[:customer][:user_attributes][:username] = @customer.user.username
    end
  end
end