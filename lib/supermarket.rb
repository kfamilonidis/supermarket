require "supermarket/version"

module Supermarket
  class Till
    attr_reader :discount_list

    def initialize(discount_list=[])
      @discount_list = discount_list
    end

    def checkout(basket)
      basket.item_list.collect{|e|e.price}.reduce(0,:+)
    end

    def apply_discount(list)
      discounts = @discount_list.select{|e|e.applicable?(list)}
      if !discounts.empty?
        discounts.each{|e|
          list = e.apply(list)
        }
      end
      list
    end
  end

  class Item
    attr_reader :price, :name

    def initialize(name:, price:)
      @name = name
      @price = price
    end

    def ==(other)
      self.name == other.name
    end
  end

  class Stocker
  end

  class Inventory
    attr_reader :item_list

    def initialize(context=nil,item=nil)
      @item_list = context ? context.item_list.dup << item : []
    end

    def add(item)
      self.class.new(self,item)
    end

    def how_many?(item)
      @item_list.count{|e| e == item}
    end
  end

  class Basket < Inventory
  end

  class Discount

    def initialize(item:, quantity:,special_price:)
      @item = item
      @quantity = quantity
      @special_price = special_price
    end

    def applicable?(item_list)
      item_list.count(@item) >= @quantity
    end

    def apply(item_list)
      if applicable?(item_list)
        [@item.class.new(name: @item.name,price: @special_price)] +
          item_list.select{|e| e == @item }.drop(@quantity) +
          item_list.reject{|e| e == @item }
      else
        item_list
      end
    end
  end
end
