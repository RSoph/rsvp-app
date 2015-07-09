class RsvpController < ApplicationController

	def index
		@texts = ["Thanks for texting The Ladies B RSVP line! We're so glad to hear from you! What's your name?", 
				"will you be coming to Kate and Danielle's wedding on Saturday, September 12? Please respond 'yes' or 'no'", 
				"Great! Will you also join us for a welcome reception on Friday evening (details tbd)? Please respond 'yes' or 'no'", 
				"Oh, that's too bad, you will be missed! If anything changes, feel free to text 'RSVP' again to start over.", 
				"Awesome! How many other people are coming with you? Just a number will do.", 
				"That's too bad! You'll be missed. How many other people are coming with you to the wedding?", 
				"Great! We are so looking forward to seeing you. If anything changes, feel free to text 'RSVP' again to start over.",
				"Sorry, I didn't get that. Could you try again with just a 'yes' or a 'no'? Or, you can call this number and leave a message instead.",
				"Thanks for texting! If you haven't done so yet, please text back 'rsvp' to start the RSVP"]

		def message(to_number, text_body)
			client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
			message = client.messages.create(
			from: "+15675234372",
			to: to_number,
			body: text_body
			)
		end

		message_body = params["Body"]
		message_body ||= "just testing"
		body = message_body.downcase.strip
		from_number = params["From"]
		from_number ||= '7187535492'
		person = Number.find_by number: from_number
		unless person
			person = Number.new
			person.number = from_number
			person.count = 0
			person.save
		end

		if body == 'thanks' || body == 'thanks!' || body == 'thank you' || body == 'thank you!' || body == 'thanks.' || body  == 'thank you.' || body  == 'ok' || body == 'ok.' # easter egg
			message(from_number, "Thanks for texting! If you have any questions, hopefully they'll be answered at our website: www.theladiesb.nyc")
		elsif body == '<3'
			message(from_number, "<3")
		elsif body.split(" ").join("") == 'upupdowndownleftrightleftrightbastart'
			message(from_number, "Never gonna give you up")
			message(from_number, "Never gonna let you down")
			message(from_number, "Never gonna run around and desert you")
			message(from_number, "Never gonna make you cry")
			message(from_number, "Never gonna say goodbye")
			message(from_number, "Never gonna tell a lie and hurt you")
			message('7187535492', 'someone got rick rolled')
		elsif body == 'rsvp' # beginning
				person.count = 1
				person.save
		  		message(from_number, @texts[0])
		  		message('7187535492', 'new rsvp')
		elsif person.count == 1 # what's your name?
			person.count += 1
			person.save
			firstname = message_body.split(" ")[0]
		 		message(from_number, "Hey #{firstname}, #{@texts[1]}") 
		elsif person.count == 2 # are you coming to the wedding?
			if body == 'yes' || body == 'yes!' # move on to the next question
				person.count += 1
				person.save
				message(from_number, @texts[2])
			elsif body == 'no' || body == 'no.'# reset count to 0 so they can start over if necessary
				person.count = 0
				person.save
	  			message(from_number, @texts[3])		
			else	# didn't understand, do not change sessions
	  			message(from_number, @texts[7])
		  	end
		elsif person.count == 3 # are you coming to friday?
			if body == 'yes' || body = 'yes!'
				person.count += 1
				person.save
	  			message(from_number, @texts[4])
			elsif body == 'no' || body == 'no.'
				person.count += 1
				person.save
	  			message(from_number, @texts[5])
			else
	  			message(from_number, @texts[7])
			end
		elsif person.count == 4 # how many people?
			message(from_number, @texts[6])
			person.count = 0 # reset count to 0 so they don't keep getting the thank you text
			person.save
		else
			message(from_number, @texts[8])
		end
		render nothing: true
	end

	private

	def rsvp_params
      params.permit(:message_body, :from_number)
    end
end
