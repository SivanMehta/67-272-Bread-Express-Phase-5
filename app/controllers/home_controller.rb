class HomeController < ApplicationController
    include BreadExpressHelpers::Baking

    def home
        if !current_user.nil? and (current_user.role? :admin or current_user.role? :shipper)
            @pending_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(15)
        end
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