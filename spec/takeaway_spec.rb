require 'takeaway'

describe Takeaway do
	context "(upon initialisation)" do
		it "should have a list of dishes" do
			takeaway = Takeaway.new
			expect(takeaway.dishes).to eq([])
		end
	end

	let(:takeaway) { Takeaway.new }
	let(:burger)   { double :dish, name: "Burger", price: 4.99 }
	let(:pie)   { double :dish, name: "Pie", price: 2.99 }
	let(:chips)   { double :dish, name: "Chips", price: 0.99 }

	it "should be able to add a dish to its list of dishes" do
		takeaway.add_dish(burger)
		expect(takeaway.dishes).to eq([burger])
	end

	it "should be able to print a list of dishes and prices" do
		takeaway.add_dish(burger)
		expect(takeaway.menu).to include("Burger")
		expect(takeaway.menu).to include("4.99")
	end

	it "should be able to work out the total value of an order" do
		takeaway.add_dish(burger)
		takeaway.add_dish(chips)
		takeaway.add_dish(pie)
		expect(takeaway.total_of({burger.name => 1, chips.name => 1, pie.name => 1})).to eq(8.97)
	end

	it "should be able to work out a total with duplicates" do
		takeaway.add_dish(burger)
		takeaway.add_dish(chips)
		expect(takeaway.total_of({burger.name => 1, chips.name => 2})).to eq(6.97)
	end

	context "(when ordering)" do
		before do
			Twilio::REST::Client.any_instance.stub_chain(:account,:sms,:messages,:create) {nil}
		end

		it "should be able to place an order" do
			takeaway.add_dish(burger)
			expect{takeaway.place_order({burger.name => 1}, 4.99)}.not_to raise_error
		end

		it "should raise an error if the payment isn't equal to the total" do
			takeaway.add_dish(burger)
			expect{takeaway.place_order({burger.name => 1}, 2.99)}.to raise_error
		end

		it "should raise an ArgumentError if you try to order something off menu" do
			expect{takeaway.place_order({burger.name => 1}, 2.99)}.to raise_error(ArgumentError)
		end

		it "should send a message if the order is valid" do
			takeaway.add_dish(burger)
			expect(takeaway).to receive(:send_message)
			takeaway.place_order({burger.name => 1}, 4.99)
		end
	end
end