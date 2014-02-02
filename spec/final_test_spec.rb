require './spec/spec_helper'

describe Takeaway do
	let(:pizza_place) 	{ Takeaway.new }
	let(:cheese_tomato) { Dish.new("Cheese and Tomato", 12.99) }
	let(:new_york) 			{ Dish.new("New York Deli", 		18.49) }
	let(:carolina) 			{ Dish.new("The Carolina",  		18.49) }

	context "(putting everything together)" do
		it "should be able to order two Cheese\\Tomato pizzas and one New York Deli pizza" do
			pizza_place.add_dish(cheese_tomato)
			pizza_place.add_dish(new_york)
			pizza_place.add_dish(carolina)
			allow(pizza_place).to receive(:gets).and_return("Menu\n", "Order\n", "Cheese and Tomato\n", "2\n", "New York Deli\n", "1\n", "done\n", "44.47\n", "Exit\n")
			
			expect{pizza_place.peruse}.to raise_error(SystemExit)
		end
	end
end
# pizza_place	= Takeaway.new
# cheese_tomato = Dish.new("Cheese and Tomato", 12.99)
# new_york = Dish.new("New York Deli", 18.49)
# carolina = Dish.new("The Carolina", 18.49)