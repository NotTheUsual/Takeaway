require 'takeaway'

describe Takeaway do
	context "(upon initialisation)" do
		it "should have a list of dishes" do
			takeaway = Takeaway.new
			expect(takeaway.dishes).to eq([])
		end
	end

	let(:takeaway) 		{ Takeaway.new }
	let(:burger)   		{ double :dish, name: "Burger", price: 4.99 }
	let(:order)				{ double :order, total: 4.99 }

	it "should be able to add a dish to its list of dishes" do
		takeaway.add_dish(burger)
		expect(takeaway.dishes).to eq([burger])
	end

	it "should be able to print a list of dishes and prices" do
		takeaway.add_dish(burger)
		expect(takeaway.menu).to include("Burger")
		expect(takeaway.menu).to include("4.99")
	end

	it "should raise an ArgumentError if it's asked to find an off-menu dish" do
		expect{takeaway.find_dish_by_name("Burger")}.to raise_error(ArgumentError)
	end

	context "(when ordering)" do
		before do
			Twilio::REST::Client.any_instance.stub_chain(:account,:sms,:messages,:create) {nil}
		end

		it "should be able to place an order" do
			takeaway.add_dish(burger)
			expect{takeaway.place_order(order, 4.99)}.not_to raise_error
		end

		it "should raise an error if the payment isn't equal to the total" do
			takeaway.add_dish(burger)
			expect{takeaway.place_order(order, 2.99)}.to raise_error
		end

		it "should send a message if the order is valid" do
			takeaway.add_dish(burger)
			expect(takeaway).to receive(:send_message)
			takeaway.place_order(order, 4.99)
		end
	end
end