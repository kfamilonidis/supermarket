require "supermarket/version"


module Supermarket

	class Till
		
		def checkout(basket)
			basket.item_list.inject(0){|num, e| num += e.price; num}
		end
	end

  class Item
  	attr_reader :price, :name

    def initialize(name:, price:)
      @name = name
      @price = Integer(price)
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
end