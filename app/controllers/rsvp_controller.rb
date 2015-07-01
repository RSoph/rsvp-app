class RsvpController < ApplicationController

	def index
		if params["Body"].downcase.strip == 'rsvp'
			message_body = params["Body"]
			message_body ||= "just testing"
			from_number = params["From"]
			from_number ||= '7187535492'
			client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token

	  		message = client.messages.create(
		    from: "+15675234372",
		    to: "#{from_number}",
		    body: "Great to hear from you! Please let us know: your name, if you will be attending the wedding, if you will be attending the Friday Night Reception (all are welcome!), and how many people you'll be bringing including yourself."
	  		)
	  	else
	  		message_body = params["Body"]
			message_body ||= "just testing"
			from_number = params["From"]
			from_number ||= '7187535492'
			client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token

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