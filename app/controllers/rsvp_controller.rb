class RsvpController < ApplicationController

	def index
		client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
		message = client.messages.create from: '15675234372', to: '16465227211', body: 'you are my lovie and I love you'
		render plain: message.status

  		# twiml = Twilio::TwiML::Response.new do |r|
		  # r.Message "Hello world!"
  		# end
  		# twiml.text
	end

	def notify

	end
end
