class RsvpController < ApplicationController

	def index
		# client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
		# message = client.messages.create from: '15675234372', to: '17187535492', body: 'hello world'
		# render plain: params

  		# twiml = Twilio::TwiML::Response.new do |r|
		  # r.Message "Hello world!"
  		# end
  		# twiml.text
  		# binding.pry

		message_body = params["Body"]
		message_body ||= "just testing"
		from_number = params["From"]
		from_number ||= '7187535492'
		client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token

  		message = client.messages.create(
	    from: "+15675234372",
	    to: "#{from_number}",
	    body: "Hey there! I got a text from you, it said #{message_body}"
  		)
  		
	end

	def notify

	end

	def rsvp_params
      params.permit(:message_body, :from_number)
    end
end


# message = client.messages.create( from: "+15675234372", to: "+17187535492", body: "console texting!")

