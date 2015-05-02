module ApplicationHelper
    include BreadExpressHelpers::Cart
    include BreadExpressHelpers::Shipping
    
    def get_address_options(user=nil)
        if user.nil? || user.role?(:admin)
            addresses = Address.active.by_recipient.to_a
        else
            addresses = user.customer.addresses.by_recipient.to_a
        end
          addresses.map{|addr| ["#{addr.recipient} : #{addr.street_1}", addr.id, { :customer => "#{addr.customer_id}"}] }
    end

    def get_user_profile
        if current_user.role? :customer
            return customer_path(Customer.find_by_user_id(current_user.id))
        else
            return user_path(current_user.id)
        end
    end

    def cart_cost
        calculate_cart_items_cost
    end

    def shipping_cost
        calculate_cart_shipping
    end
end
