require 'twilio-ruby'

class Takeaway
	attr_reader :dishes

	def initialize
		@dishes = []
		account_sid, auth_token = "account_sid", "auth_token" # Removed because the credentials I had appear to have been deleted, so...
		@twilio_client = Twilio::REST::Client.new account_sid, auth_token
	end

	def add_dish(dish)
		@dishes << dish
	end

	def menu
		@dishes.inject("") do |output, dish|
			output += "#{dish.name}".ljust(30,'.') + "#{dish.price}".rjust(5,'.') + "\n"
		end
	end

	def place_order(order, payment)
		raise "Payment is incorrect" unless payment == total_of(order)
		send_message
	end

	def total_of order
		order.inject(0) do |total, (dish_name, quantity)|
			dish = find_dish_by_name(dish_name)
			total += dish.price * quantity
			total.round(2)
		end	
	end

	def find_dish_by_name dish_name
		error_if_nil = -> { raise ArgumentError, "#{dish_name} is not on the menu" }
		@dishes.find(error_if_nil) {|dish| dish.name == dish_name}
	end

	def send_message
		message = new_message
		@twilio_client.account.sms.messages.create(
			from: '+441985250053',
			to: 	'+447917322442',
			body: message
		)
	end

	def new_message
		t = Time.now + 1*60*60 # 1 hour in the future (units are seconds)
		t.strftime("Thank you! Your order was placed successfully and will be delivered before %k:%M")
	end

	# This is more for my happiness than the task itself - ignore
	# I mean, there are no tests for this, so you'll probably do it anyway, but I thought I'd be sure
	def peruse
		puts "Welcome! What would you like to do?"
		loop do
			print_options
			selection = gets.chomp
			case selection
			when "Menu"
				puts "-" * 35
				puts menu
				puts "-" * 35
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

	def take_order
		order = {}
		puts "What would you like to eat?"
		puts "(type 'done' when done)"
		dish_name = gets.chomp
		while dish_name != 'done'
			puts "How many would you like?"
			quantity = gets.chomp.to_i
			order[dish_name] = quantity
			puts "What would you like to eat?"
			puts "(type 'done' when done)"
			dish_name = gets.chomp
		end
		begin
			total = total_of order
		rescue ArgumentError => e
			puts e.message
			puts "Would you like to start again? (y/n)"
			choice = gets.chomp
			take_order if choice == "y"
			exit if choice == "n"
		else
			pay(order,total)
		end
	end

	def pay(order,total)
		puts "That'll be £#{total}"
		payment = gets.chomp.to_f
		begin
			place_order(order, payment)
		rescue
			puts "I'm sorry, but that's not the right amount - please try again"
			pay(order,total)
		else
			"Thank you for your order"
		end
	end

end