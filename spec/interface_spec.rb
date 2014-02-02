require 'stringio'
require './spec/spec_helper'

def capture_stdout &block
  old_stdout = $stdout
  fake_stdout = StringIO.new
  $stdout = fake_stdout
  block.call
  fake_stdout.string
ensure
  $stdout = old_stdout
end


class PizzaPlace; include Interface; end

describe PizzaPlace do
		let(:pizza_place)  { PizzaPlace.new }
		let(:pizza)			 { double :dish, name: "Pizza", price: 4.99 }
		let(:pizza_line)	 { double :lineitem, dish: pizza, quantity: 2 }
		let(:pizza_order) { double :order, total: 9.98, lines: [pizza_line] }

	it "should be able to print options for a user" do
		printed = capture_stdout do
	    pizza_place.print_options
	  end
  	expect(printed).to eq("Menu   | See all the items available for order\nOrder  | Place an order\nExit   | Leave the takeaway\n")
	end

	context "(perusing)" do
		before do
			pizza_place.stub(:menu) { "Menu" }
			pizza_place.stub(:take_order) { nil }
		end

		it "should be able to exit the menu" do
			allow(pizza_place).to receive(:gets).and_return("Exit\n")

			expect{pizza_place.peruse}.to raise_error(SystemExit)
		end

		it "should initially print a welcome message" do
			allow(pizza_place).to receive(:gets).and_return("Exit\n")
		 	
		 	expect(pizza_place).to receive(:puts).with("Welcome! What would you like to do?")
		 	expect(pizza_place).to receive(:puts).at_least(3).times
		 	
		 	expect{pizza_place.peruse}.to raise_error(SystemExit)
		end

		it "should print the available options" do
			allow(pizza_place).to receive(:gets).and_return("Exit\n")
			
			expect(pizza_place).to receive(:print_options)
			expect{pizza_place.peruse}.to raise_error(SystemExit)
		end

		it "should get input from the user" do
			allow(pizza_place).to receive(:gets).and_return("Exit\n")
			
			expect(pizza_place).to receive(:gets)
			expect{pizza_place.peruse}.to raise_error(SystemExit)
		end

		it "should call the establishment's menu function when asked" do
			allow(pizza_place).to receive(:gets).and_return("Menu\n", "Exit\n")
			
			expect(pizza_place).to receive(:menu)
			expect{pizza_place.peruse}.to raise_error(SystemExit)
		end

		it "should print the menu when asked" do
		  allow(pizza_place).to receive(:print_options).and_return(nil)
		  allow(pizza_place).to receive(:gets).and_return("Menu\n", "Exit\n")

		  expect(pizza_place).to receive(:puts).once
		  expect(pizza_place).to receive(:puts).with('-' * 35)
		  expect(pizza_place).to receive(:puts).with("Menu")
		  expect(pizza_place).to receive(:puts).with('-' * 35)

		  expect{pizza_place.peruse}.to raise_error(SystemExit)
		end

		it "should take an order when asked" do
			allow(pizza_place).to receive(:gets).and_return("Order\n", "Exit\n")
			
			expect(pizza_place).to receive(:take_order)
			
			expect{pizza_place.peruse}.to raise_error(SystemExit)
		end

		it "should be able to print the menu, then order" do
			allow(pizza_place).to receive(:gets).and_return("Menu\n", "Order\n", "Exit\n")
			
			expect(pizza_place).to receive(:menu)
			expect(pizza_place).to receive(:take_order)

			expect{pizza_place.peruse}.to raise_error(SystemExit)
		end
	end

	context "(taking the order)" do
		before do
			pizza_place.stub(:pay) 							  { nil }
			allow(pizza_place).to receive(:find_dish_by_name).with("Pizza").and_return(pizza)
			allow(pizza_place).to receive(:find_dish_by_name).with("Chips").and_raise(ArgumentError, "message")
		end

		it "should create a new order object" do
			allow(pizza_place).to receive(:gets).and_return("done\n")
			
			expect(Order).to receive(:new)
			
			pizza_place.take_order
		end

		it "should print out instructions" do
			allow(pizza_place).to receive(:gets).and_return("done\n")

			expect(pizza_place).to receive(:puts).with("What would you like to eat?")
			expect(pizza_place).to receive(:puts).with("(type 'done' when done)")
			
			pizza_place.take_order
		end

		it "should take input form the user" do
			allow(pizza_place).to receive(:gets).and_return("done\n")
			
			expect(pizza_place).to receive(:gets)
			pizza_place.take_order
		end

		it "should be able to break out of the loop after none-done input" do
			allow(pizza_place).to receive(:gets).and_return("Pizza\n", "done\n")
		
			expect(pizza_place).to receive(:pay)

			pizza_place.take_order
		end

		it "should search for the dish associated with the inputted name" do
			allow(pizza_place).to receive(:gets).and_return("Pizza\n", "done\n")
		
			expect(pizza_place).to receive(:find_dish_by_name).with("Pizza")

			pizza_place.take_order
		end

		it "should ask for a new input if the user asks for an off-menu dish" do
			allow(pizza_place).to receive(:gets).and_return("Chips\n", "done\n")

			expect(pizza_place).to receive(:puts).twice
			expect(pizza_place).to receive(:puts).with("message")
			expect(pizza_place).to receive(:puts).with("Would you like to select another dish?")
			expect(pizza_place).to receive(:puts).with("(type 'done' when done)")

			pizza_place.take_order
		end

		it "should ask for a quantity once it has accepted a dish" do
			allow(pizza_place).to receive(:gets).and_return("Pizza\n", "1\n", "done\n")

			expect(pizza_place).to receive(:puts).exactly(2).times
			expect(pizza_place).to receive(:puts).with("How many would you like?")
			expect(pizza_place).to receive(:gets)
			expect(pizza_place).to receive(:puts).at_least(2).times

			pizza_place.take_order
		end

		it "should create a new line item with the dish and the quantity" do
			allow(pizza_place).to receive(:gets).and_return("Pizza\n", "1\n", "done\n")

			expect(LineItem).to receive(:new).with(pizza,1)

			pizza_place.take_order
		end

		it "should add the line item to the order" do
			allow(pizza_place).to receive(:gets).and_return("Pizza\n", "1\n", "done\n")

			expect_any_instance_of(Order).to receive(:add_line)

			pizza_place.take_order
		end

		it "should ask for a new dish once it has added the item to the order" do
			allow(pizza_place).to receive(:gets).and_return("Pizza\n", "1\n", "done\n")

			expect(pizza_place).to receive(:puts).exactly(3).times
			expect(pizza_place).to receive(:puts).with("Would you like to select another dish?")
			expect(pizza_place).to receive(:puts).with("(type 'done' when done)")

			pizza_place.take_order
		end
	end

	context "(attempting to pay)" do
		before do
			allow(pizza_place).to receive(:place_order).with(pizza_order,9.98).and_return(nil)
			allow(pizza_place).to receive(:place_order).with(pizza_order,8.88).and_raise("message")
		end

		it "should ask you to pay the correct total" do
			allow(pizza_place).to receive(:gets).and_return("9.98")

			expect(pizza_place).to receive(:puts).with("That'll be £9.98")
			expect(pizza_place).to receive(:puts).at_least(1).times

			pizza_place.pay_for(pizza_order)
		end

		it "should take payment from the user (as typed in number)" do
			allow(pizza_place).to receive(:gets).and_return("9.98")
		
			expect(pizza_place).to receive(:gets)

			pizza_place.pay_for(pizza_order)
		end

		it "should call place_order with the computed order" do
			allow(pizza_place).to receive(:gets).and_return("9.98")

			expect(pizza_place).to receive(:place_order).with(pizza_order,9.98)
		
			pizza_place.pay_for(pizza_order)
		end

		it "should handle the error if you add the wrong payment" do
			allow(pizza_place).to receive(:gets).and_return("8.88", "9.98")

			expect(pizza_place).to receive(:puts).once
			expect(pizza_place).to receive(:puts).with("I'm sorry, but that's not the right amount - please try again")
			expect(pizza_place).to receive(:puts).at_least(2).times

			expect{pizza_place.pay_for(pizza_order)}.not_to raise_error
		end

		# I wanted a test for the recursive call, but receive(:pay_for).once/twice didn't track right
		# So, checking for the extra puts statement above does track, for now, but is a little brittle

		it "should print a confirmation message before the end" do
			allow(pizza_place).to receive(:gets).and_return("9.98")

			expect(pizza_place).to receive(:puts).once
			expect(pizza_place).to receive(:puts).with("Thank you for your order")

			pizza_place.pay_for(pizza_order)
		end
	end
end