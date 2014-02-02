# Takeaway

Models a system for managing orders at takeaway restaurants.

## Main Classes

OK, so there are four main classes
- Takeaway
- Dish
- Order
- LineItem

The Takeaway can
- add Dishes
- return a menu of dish names and prices
- place an order, with a given Order and payment value
- find a dish from the menu given its name
- send a confirmation message (well, kinda...)

Each Dish
- has a name
- has a price

An Order
- has a list of LineItems
- can add a new LineItem
- can generate its total value

Each LineItem
- has a dish
- has a quantity
- can work out its cost

So that's how that works. There's a version with only the Takeaway and Dish classes tagged as Final-Takeaway-Dish-Version, but it was suggested that more classes might be a better approach, so now there are more classes. The Takeaway class can't actually send messages as Twilio have deleted my account and stopped responding to me, but all the stubs seem to work (and I have the text history to show it did at one point send (maybe too many) messages).

## Interface

Now, having spent a couple of weeks building things that don't actually work (well, I mean, they work, but you can't work them), I thought I'd try to graft the interface from the student directory onto this project, so I could work out how everything might link together. So, Takeaway now uses a module called Interface, which lets me play with it in irb. All the tests for this are commented out by default (both interface_spec.rb and final_test_spec.rb), as they aren't relevant to the specification and run slightly slowly owing to having to wait for Twilio to fail. This next bit is mostly for my reference later.

The interface
- can present a list of options
- will call the Takeaway menu if requested
- can take an order
-- will ask for dishes (calling an error if the given dish is not found)
-- will ask for a quantity
-- will create a LineItem and add it to the order
-- will repeat until 'done'
- will ask for payment
-- will repeat until the payment is correct
- will apologise for Twilio failing

To get it to work in irb
		require './lib/takeaway'
		require './lib/dish'
		require './lib/order'
		require './lib/line_item'

		pizza_place	= Takeaway.new
		cheese_tomato = Dish.new("Cheese and Tomato", 12.99)
		new_york = Dish.new("New York Deli", 18.49)
		carolina = Dish.new("The Carolina", 18.49)

		pizza_place.add_dish(cheese_tomato)
		pizza_place.add_dish(new_york)
		pizza_place.add_dish(carolina)

		pizza_place.peruse
Then, follow onscreen instuctions (exactly - it won't check for spelling/case errors).

It did help me conceptualise the exercise, but I'm not necessarily sure it produced any decent code... Still fun to be able to actually use something you've coded.