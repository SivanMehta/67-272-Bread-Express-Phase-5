class HomeController < ApplicationController
    include BreadExpressHelpers::Baking

    def home
        @unshipped_ois = OrderItem.unshipped.paginate(:page => params[:page]).per_page(10)
        @shipped_ois = OrderItem.shipped.paginate(:page => params[:page]).per_page(10)
    end

    def toggle
        @oi = OrderItem.find(params[:id])
        if @oi.shipped_on.nil?
            @oi.shipped_on = Date.today
        else
            @oi.shipped_on = nil
        end

        @oi.save!

        flash[:notice] = "Toggled Order Item to cart"
        redirect_to :back
    end

    def about
    end

    def privacy
    end

    def contact
    end

    def cart 
    end
end