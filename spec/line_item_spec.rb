require 'line_item'

describe LineItem do
	let(:burger) { double :dish, name: "Burger", price: 4.99 }
	let(:line)   { LineItem.new(burger) }
	let(:line2)	 { LineItem.new(burger, 2) }

	context "(upon initialization)" do
		it "should have a dish" do
			expect(line.dish).to eq(burger)
		end

		it "should have a default quantity of 1" do
			expect(line.quantity).to eq(1)
		end

		it "should be able to be initialised with a higher quantity" do
			expect(line2.quantity).to eq(2)
		end
	end

	it "should know its total cost" do
		expect(line2.cost).to eq(9.98)
	end
end