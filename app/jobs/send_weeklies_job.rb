class SendWeekliesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    User.all.each do |user|
      TodoMailer.with(:mail => user.email).weekly_list.deliver_now
    end
  end
end
