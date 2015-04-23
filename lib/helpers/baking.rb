module BreadExpressHelpers
  module Baking

    def create_baking_list_for(category)
        # returns a hash of item name and quantity to be baked for a 
        # particular category of items like bread, muffins, etc.

        all_items = Item.for_category(category).map(&:name).sort

        # all these items and their quantities
        baking_list = Hash[all_items.map{|name| [name, 0]}]

        # get the name, quantity of all unshipped, non nil items
        unshipped_items = OrderItem.unshipped.map{|oi| [oi.item.name, oi.quantity] if all_items.include?(oi.item.name)}.compact!
        
        # increment baking_list quantities for each order
        unshipped_items.each{|name, quant| baking_list[name] += quant} unless unshipped_items.nil?

        # bakers don't need to see things that haven't been ordered (reduce memory load)
        baking_list.delete_if{|key, value| value == 0}
        return baking_list
    end
  end
end