require 'order'

describe Order do
	let(:order)       { Order.new }
	let(:two_burgers) { double :lineitem, cost: 9.98 }
	let(:one_pizza)   { double :lineitem, cost: 7.99 }

	context "(upon initialization)" do
		it "should have a total of 0" do
			expect(order.total).to eq(0)
		end

		it "should have an empty lines array" do
			expect(order.lines).to eq([])
		end
	end

	it "should be able to add a line item" do
		order.add_line(two_burgers)
		expect(order.lines).to eq([two_burgers])
	end

	it "should update the total after a line item is added" do
		order.add_line(two_burgers)
		expect(order.total).to eq(9.98)
	end

	it "should be able to cope with multiple lines" do
		order.add_line(two_burgers)
		order.add_line(one_pizza)
		expect(order.total).to eq(17.97)
		expect(order.lines).to eq([two_burgers, one_pizza])
	end
end