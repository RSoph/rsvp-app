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
		@texts = ["Great to hear from you! What's your name?", 
				"Hey #{firstname}, will you be able to come to Kate and Danielle's wedding? Please give me a 'yes' or a 'no'", 
				"Great! Will you also join us for the Friday Night Reception? Please give me a 'yes' or a 'no'", 
				"That's too bad, you will be missed! If anything changes, feel free to text 'rsvp' again to start over!", 
				"Fantastic! How many other people are coming with you? Just a number will do.", 
				"That's too bad, you'll be missed. How many other people are coming with you to the wedding?", 
				"Great! Looking forward to seeing you. If anything changes, feel free to text 'rsvp' again to start over!",
				"I didn't get that, could you try again with just a 'yes' or a 'no'?"]
		message_body = params["Body"]
		message_body ||= "just testing"
		from_number = params["From"]
		from_number ||= '7187535492'
		from_hash ||= {}
		from_hash[from_number] ||= 0
		client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token

		if message_body.downcase.strip == 'rsvp' # beginning
			from_hash[from_number] = 1
	  		message = client.messages.create(
		    from: "+15675234372",
		    to: "#{from_number}",
		    body: @texts[0]
	  		)
		elsif from_hash[from_number] == 1 # what's your name?
			from_hash[from_number] += 1
			firstname = body.split(" ")[0]
	  		message = client.messages.create(
		    from: "+15675234372",
		    to: "#{from_number}",
		    body: @texts[1]
	  		)
		elsif from_hash[from_number] == 2 # are you coming to the wedding?
			if message_body.downcase.strip == 'yes' # move on to the next question
				from_hash[from_number] += 1
				message = client.messages.create(
			    from: "+15675234372",
			    to: "#{from_number}",
			    body: @texts[2]
		  		)
			elsif message_body.downcase.strip = 'no' # reset sessions to 0 so they can start over if necessary
				from_hash[from_number] = 0
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
		elsif from_hash[from_number] = 3 # are you coming to friday?
			if message_body.downcase.strip == 'yes'
				from_hash[from_number] += 1
				message = client.messages.create(
			    from: "+15675234372",
			    to: "#{from_number}",
			    body: @texts[4]
		  		)	
			elsif message_body.downcase.strip = 'no'
				from_hash[from_number] += 1
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
		elsif from_hash[from_number] = 4 # how many people?
				message = client.messages.create(
			    from: "+15675234372",
			    to: "#{from_number}",
			    body: @texts[6]
		  		)	
		end
	end

	def rsvp_params
      params.permit(:message_body, :from_number)
    end
end