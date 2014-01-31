require 'dish'

describe Dish do
	let(:burger) { Dish.new("Burger", 4.99) }

	it "should know its name" do
		expect(burger.name).to eq("Burger")
	end

	it "should know its price" do
		expect(burger.price).to eq(4.99)
	end

	context "(upon initialisation)" do
		let(:chips) { Dish.new("Chips", 1.20) }
		
		it "should have a name" do
			expect(chips.name).to eq("Chips")
		end

		it "should have a price" do
			expect(chips.price).to eq(1.20)
		end
	end
end