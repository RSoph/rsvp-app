class RsvpController < ApplicationController

	def index
		client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
		message = client.messages.create from: '15675234372', to: '17187535492', body: 'hello world'
		render plain: params

  		# twiml = Twilio::TwiML::Response.new do |r|
		  # r.Message "Hello world!"
  		# end
  		# twiml.text
  		# binding.pry
	end

	def notify

	end
end
