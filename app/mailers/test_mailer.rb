class TestMailer < ActionMailer::Base

  Sidekiq::Extensions::DelayedMailer.sidekiq_options :queue => 'mailers'
   default from: '"Test" <test@example.com>'
 
  def notify(to_email, links=50, subject=nil, body=nil)
    subject ||= "Test Email Please Ignore"
    body ||= "<html><head></head><body>#{(0..links.to_i).to_a.map{|i| "<h1>Test Email</h1><a href='http://example.com/#{i}'>i</a>"}.join("")}<a href='http://example.com/users/unsubscribe'>i</a></body></html>"
    mail({ to: to_email, subject: subject, body: body.dup, content_type: "text/html" })
  end
end