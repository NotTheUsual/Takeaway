class Order
	attr_reader :lines

	def initialize
		@lines = []
	end

	def add_line(line_item)
		@lines << line_item
	end

	def total
		@lines.inject(0) { |total,line| total += line.cost }
	end
end
