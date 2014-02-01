class LineItem
	attr_reader :dish, :quantity

	def initialize(dish, quantity=1)
		@dish, @quantity = dish, quantity
	end

	def cost
		dish.price * quantity
	end
end