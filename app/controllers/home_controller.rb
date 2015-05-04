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
            flash[:notice] = "Marked #{@oi.quantity} #{@oi.item.name.pluralize(@oi.quantity)} as shipped"
        else
            @oi.shipped_on = nil
            flash[:notice] = "Marked #{@oi.quantity} #{@oi.item.name.pluralize(@oi.quantity)} as unshipped"
        end

        @oi.save!
        redirect_to :back
    end

    def about
    end

    def privacy
    end

    def contact
    end

    def cart 
        if current_user.nil? or current_user.role? :baker or current_user.role? :shipper
            flash[:alert] = "You are not authorized to take this action"
            redirect_to :home
        end
    end
end