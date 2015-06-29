class RsvpController < ApplicationController

	def index
  		twiml = Twilio::TwiML::Response.new do |r|
    		r.Message "Hello world!"
  		end
  		twiml.text
	end
end
