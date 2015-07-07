class RsvpController < ApplicationController

	def index
		message_body = params["Body"]
		message_body ||= "just testing"
		from_number = params["From"]

		client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token

		if message_body.downcase.strip == 'rsvp'
	  		message = client.messages.create(
		    from: "+15675234372",
		    to: "#{from_number}",
		    body: "Great to hear from you! Please let us know the following: 1) Your name 2) If you will be attending the wedding..."
		    )
	  		message = client.messages.create(
		    from: "+15675234372",
		    to: "#{from_number}",
		    body: "...3) If you will be attending the Friday Night Reception - all are welcome! 4) How many people you'll be bringing including yourself."
	  		)
	  	else
	  		message = client.messages.create(
		    from: "+15675234372",
		    to: "#{from_number}",
		    body: "Thanks for the response! If your RSVP changes, you can always text again."
	  		)

	  		message = client.messages.create(
		    from: "+15675234372",
		    to: "7187535492",
		    body: "incoming rsvp: #{message_body}"
	  		)
	  	end
		render nothing: true
	end

	def count
		@texts = ["Thanks for texting The Ladies B RSVP line! We're so glad to hear from you! What's your name?", 
				"will you be coming to Kate and Danielle's wedding on Saturday, September 12? Please respond 'yes' or 'no'", 
				"Great! Will you also join us for a welcome reception on Friday evening (details tbd)? Please respond 'yes' or 'no'", 
				"Oh, that's too bad, you will be missed! If anything changes, feel free to text 'RSVP' again to start over.", 
				"Awesome! How many other people are coming with you? Just a number will do.", 
				"That's too bad! You'll be missed. How many other people are coming with you to the wedding?", 
				"Great! We are so looking forward to seeing you. If anything changes, feel free to text 'RSVP' again to start over.",
				"Sorry, I didn't get that. Could you try again with just a 'yes' or a 'no'? Or, you can call this number and leave a message instead."]

		message_body = params["Body"]
		message_body ||= "just testing"
		from_number = params["From"]
		from_number ||= '7187535492'
		person = Number.find_by number: from_number
		unless person
			person = Number.new
			person.number = from_number
			person.count = 0
			person.save
		end
		client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token

		if message_body.downcase.strip == 'rsvp' # beginning
			person.count = 1
			person.save
	  		message = client.messages.create(
		    from: "+15675234372",
		    to: "#{from_number}",
		    body: @texts[0]
	  		)
		elsif person.count == 1 # what's your name?
			person.count += 1
			person.save
			firstname = message_body.split(" ")[0]
	  		message = client.messages.create(
		    from: "+15675234372",
		    to: "#{from_number}",
		    body: "Hey #{firstname}, #{@texts[1]}"
	  		)
		elsif person.count == 2 # are you coming to the wedding?
			if message_body.downcase.strip == 'yes' # move on to the next question
				person.count += 1
				person.save
				message = client.messages.create(
			    from: "+15675234372",
			    to: "#{from_number}",
			    body: @texts[2]
		  		)
			elsif message_body.downcase.strip == 'no' # reset sessions to 0 so they can start over if necessary
				person.count = 0
				person.save
				message = client.messages.create(
			    from: "+15675234372",
			    to: "#{from_number}",
			    body: @texts[3]
		  		)				
			else	# didn't understand, do not change sessions
				message = client.messages.create(
			    from: "+15675234372",
			    to: "#{from_number}",
			    body: @texts[7]
		  		)	
		  	end
		elsif person.count == 3 # are you coming to friday?
			if message_body.downcase.strip == 'yes'
				person.count += 1
				person.save
				message = client.messages.create(
			    from: "+15675234372",
			    to: "#{from_number}",
			    body: @texts[4]
		  		)	
			elsif message_body.downcase.strip == 'no'
				person.count += 1
				person.save
				message = client.messages.create(
			    from: "+15675234372",
			    to: "#{from_number}",
			    body: @texts[5]
		  		)	
			else
				message = client.messages.create(
			    from: "+15675234372",
			    to: "#{from_number}",
			    body: @texts[7]
		  		)
			end
		elsif person.count == 4 # how many people?
				message = client.messages.create(
			    from: "+15675234372",
			    to: "#{from_number}",
			    body: @texts[6]
		  		)	
		end
		render nothing: true
	end

	def rsvp_params
      params.permit(:message_body, :from_number)
    end
end
