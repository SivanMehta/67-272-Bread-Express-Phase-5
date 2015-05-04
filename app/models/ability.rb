class Ability
  include CanCan::Ability
  
  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user
    
    # set authorizations for different user roles
    if user.role? :admin
        # they get to do it all
        can :manage, :all
        
    elsif user.role? :customer
        # they can read their own profile
        can :show, Customer do |c|  
            c.user_id == user.id
        end

        can :show, User do |u|
            u.id == user.id
        end

        # they can update their own profile
        can :update, User do |u|
            u.id == user.id
        end
        can :update, Customer do |c|
            c.user_id == user.id
        end

        # can read item information
        can :read, Item

        # can add an item to the cart
        can :add_to_cart, Item
        can :remove_from_cart, Item

        # can see their own orders
        can :read, Order do |this_order|
            my_orders = Order.find_all_by_customer_id(user.customer.id).map { |o| o.id }
            my_orders.include? this_order.id
        end

        # can place an order for themselves
        can :create, Order

        # can make and update an address for themselves
        can :create, Address

        can :update, Address do |this_address|
            user_customer = user.customer.id
            this_address.customer_id == user_customer
        end

        can :read, Address do |this_address|
            user_customer = user.customer.id
            this_address.customer_id == user_customer
        end

        can :home, :home

    elsif user.role? :shipper or user.role? :baker

        can :read, User do |this_user|
            this_user == user.id
        end

        can :update, User do |this_user|
            this_user == user.id
        end
        
    else
        # guests can read the items
        can :read, Item
        can :home, :home

        # guests can make a new customer account for themself
        can :create, User
        can :create, Customer
    end
  end
end