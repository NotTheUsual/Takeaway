module Interface
	def peruse
		puts "Welcome! What would you like to do?"
		loop do
			print_options
			selection = gets.chomp
			case selection
			when "Menu"
				print_menu
			when "Order"
				take_order
			when "Exit"
				exit
			end
		end
	end

	def print_options
		puts "Menu".ljust(7)  + "| See all the items available for order"
		puts "Order".ljust(7) + "| Place an order"
		puts "Exit".ljust(7)  + "| Leave the takeaway"
	end

	def print_menu
		puts "-" * 35
		puts menu
		puts "-" * 35
	end

	def take_order
		order = Order.new
		puts "What would you like to eat?"
		puts "(type 'done' when done)"
		dish_name = gets.chomp
		while dish_name != 'done'
			begin
				dish = find_dish_by_name(dish_name)
			rescue ArgumentError => e
				puts e.message
				ask_for_another_dish
				dish_name = gets.chomp
				next
			end
			puts "How many would you like?"
			quantity = gets.chomp.to_i
			order.add_line(LineItem.new(dish,quantity))
			ask_for_another_dish
			dish_name = gets.chomp
		end
		pay_for order
	end

	def ask_for_another_dish
		puts "Would you like to select another dish?"
		puts "(type 'done' when done)"
	end

	def pay_for order
		puts "That'll be £#{order.total}"
		payment = gets.chomp.to_f
		begin
			place_order(order, payment)
		rescue ArgumentError
			puts "I'm sorry, but that's not the right amount - please try again"
			pay_for order
		rescue
			puts "Twilio's failed, sorry"
		else
			puts "Thank you for your order"
		end
	end
end