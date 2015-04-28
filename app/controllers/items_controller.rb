class ItemsController < ApplicationController

    before_action :set_item, only: [:show, :edit, :update] #, :destroy]
    authorize_resource

    def index
        @active_items = Item.active.alphabetical.paginate(:page => params[:page]).per_page(10)
        @inactive_items = Item.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
    end

    def show
        @item_price = ItemPrice.new
    end

    def edit
    end

    def update
        if @item.update(item_params)
            redirect_to items_path, notice: "The item was revised in the system."
        else
            render action: 'edit'
        end
    end

    def new
        @item = Item.new
        item_price = @item.item_prices.build
    end

    def create
        @item = Item.new(item_params)

        if @item.save
            # if saved to database
            redirect_to item_path(@item), notice: "#{@item.name} was added to the system."
        else
            # return to the 'new' form
            render :action => 'new'
        end
    end

    private
        def set_item
            @item = Item.find(params[:id])
        end

        def item_params
            params.require(:item).permit(:name, :category, :picture, :units_per_item, :weight, :description)
        end
end