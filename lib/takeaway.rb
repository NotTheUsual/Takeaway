class Takeaway
	attr_reader :dishes

	def initialize
		@dishes = []
	end

	def add_dish(dish)
		@dishes << dish
	end

	def menu
		@dishes.inject("") do |output, dish|
			output += "#{dish.name}".ljust(30,'.') + "#{dish.price}" + "\n"
		end
	end

	def total_of order
		total = 0
		order.each do |dish_name,quantity|
			dish = find_dish_by_name(dish_name)
			raise ArgumentError, "#{dish_name} is not on the menu" if dish.nil?
			total += dish.price * quantity
		end
		total.round(2)
	end

	def find_dish_by_name dish_name
		@dishes.find {|dish| dish.name == dish_name}
	end

	def place_order(order, payment)
		raise "Payment is incorrect" unless payment == total_of(order)
	end
end