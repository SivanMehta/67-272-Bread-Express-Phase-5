class AddressesController < ApplicationController
  before_action :check_login
  before_action :set_address, only: [:show, :edit, :update, :destroy]
  authorize_resource
  
  def index
    if current_user.role? :customer
      @active_addresses = current_user.customer.addresses.active.by_recipient.paginate(:page => params[:page]).per_page(10)
      @inactive_addresses = current_user.customer.addresses.inactive.by_recipient.paginate(:page => params[:page]).per_page(10)      
    else
      @active_addresses = Address.active.by_customer.by_recipient.paginate(:page => params[:page]).per_page(10)
      @inactive_addresses = Address.inactive.by_customer.by_recipient.paginate(:page => params[:page]).per_page(10)
    end
  end

  def show
    @customer = @address.customer
  end

  def new
    @address = Address.new
  end

  def edit
  end

  def create
    @address = Address.new(address_params)
    
    if @address.save
      redirect_to customer_path(@address.customer_id), notice: "The address was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @address.update(address_params)
      redirect_to customer_path(@address.customer_id), notice: "The address was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    if !@address.is_destroyable?
      flash[:alert] = "Could not remove already shipped address"
      redirect_to :back
    else
      @address.destroy
      redirect_to customer_path(@address.customer_id), notice: "The address was removed from the system."
    end
  end

  private
  def set_address
    @address = Address.find(params[:id])
  end

  def address_params
    set_customer_id
    params.require(:address).permit(:recipient, :street_1, :street_2, :city, :state, :zip, :active, :is_billing, :customer_id)
  end

  def set_customer_id
    unless current_user.role?(:admin)
      params[:address][:customer_id] = current_user.customer.id
    end
  end

end