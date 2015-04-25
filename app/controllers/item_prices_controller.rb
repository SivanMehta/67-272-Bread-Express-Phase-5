class ItemPricesController < ApplicationController

    def create
        @item_price = ItemPrice.new(item_price_params)
        @item_price.start_date = Date.today
        @item_price.item_id = params[:item_id]

        if @item_price.save!
            item = Item.find(@item_price.item_id)
            flash[:notice] = "#{item.name} has been created."
            redirect_to item
        else
            flash[:notice] = "Could not update price"
        end
    end

    def update
        if @item_price.update(item_price_params)
            redirect_to items_path, notice: "The price was revised in the system."
        else
            render action: 'edit'
        end
    end

    private
        def item_price_params
            params.require(:item_price).permit(:price)
        end
end
