class RsvpController < ApplicationController

	def index

		message_body = params["Body"]
		message_body ||= "just testing"
		from_number = params["From"]
		from_number ||= '7187535492'
		client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token

		if params["Body"].downcase.strip == 'rsvp'
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
	  	end
	end

	def notify
	end

	def rsvp_params
      params.permit(:message_body, :from_number)
    end
end