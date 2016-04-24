class TestWorker

  include Sidekiq::Worker

  def perform(limit=1000, links=50, delay=false, open=true, click=true)
    Ahoy::Message.destroy_all
    TestMailer.class_eval do
      track open: !!(open)
      track click: !!(click)
    end
    emails ||= (1..limit.to_i).to_a.map{|i| "test+#{i}@example.com" }
    emails.each_with_index do |email, index|
      email = TestMailer.notify(email, links)
      "TestWorker ##{index}:: #{email['to']}" # Important:: email['to'] necessary to store.
      if !!(delay)
        email.deliver_later#(wait_until: DateTime.now.change(hour: 19))
      else
        email.deliver_now
      end
    end
    `rm -rf #{Rails.root}/tmp/emails`
  end
end
