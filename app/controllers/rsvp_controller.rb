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



  # 		 account_sid = "I put my ID here"
  # auth_token = "I put my auth token here"
  # twilio_phone_number = "xxxxxxxxx"

		message_body = params["Body"]
		from_number = params["From"]
		client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token

  # @client = Twilio::REST::Client.new(account_sid, auth_token)
  		@client.account.sms.messages.create(
	    from: "+15675234372",
	    to: "+1#{from_number}",
	    body: "Hey there! I got a text from you, it said #{message_body}"
  		)
	end

	def notify

	end
end
