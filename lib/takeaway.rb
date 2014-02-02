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
		raise "Payment is incorrect" unless payment == order.total
		send_message
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
end