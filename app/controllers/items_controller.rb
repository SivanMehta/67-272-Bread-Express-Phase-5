class ItemsController < ApplicationController

    before_action :set_item, only: [:show] #, :edit, :update, :destroy]

    def index
        @active_items = Item.active.alphabetical.paginate(:page => params[:page]).per_page(10)
        @inactive_items = Item.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
    end

    def show
    end

    private
        def set_item
            @item = Item.find(params[:id])
        end
end