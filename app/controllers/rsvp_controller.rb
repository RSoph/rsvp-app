class RsvpController < ApplicationController

	MY_NUMBER = "+17187535492"
	TO_EMAIL = "theladiesb@gmail.com"
	# SMTP_HOST = "<SMTP hostname here>"
	# SMTP_USER = "<your username here>"
	# SMTP_PASSWORD = "<your password here>"

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

	  		message = client.messages.create(
		    from: "+15675234372",
		    to: "7187535492",
		    body: "incoming rsvp: #{params["Body"]}"
	  		)
	  	end
	end

	def notify
	end

	# def answer
	#     Twilio::TwiML::Response.new do |r|
	#         r.Say "Thanks for calling, please leave a message"
	# 		r.Record :action => "/save-recording", :method => "get"
	#         end
	#     end.text
	# end

	# def save
	#     send_message("New Message on the hotline",
	#                  "Message length: #{params['RecordingDuration']}",
	#                  params['RecordingUrl'] + '.mp3')
	 
	#     Twilio::TwiML::Response.new do |r|
	#         r.Say "Thank you for calling. Bye!"
	#         r.Hangup
	#     end.text		
	# end

	# def send_message(subject, message, file_url)
 #    Pony.mail({
 #        :to => TO_EMAIL
 #        :body => message,
 #        :via => :smtp,
 #        :via_options => {
 #            # :address => SMTP_HOST,
 #            # :user_name => SMTP_USER,
 #            # :password => SMTP_PASSWORD,
 #            # :port => SMTP_PORT,
 #            :authentication => :plain },
 #        :attachments => {"message.mp3" => open(file_url) {|f| f.read }}
 #    })
	# end

	def rsvp_params
      params.permit(:message_body, :from_number)
    end
end