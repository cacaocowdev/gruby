require 'rufus-scheduler'

return if defined?(Rails::Console) || Rails.env.test? || File.split($PROGRAM_NAME).last == 'rake'

s = Rufus::Scheduler.singleton

# every sunday at 15:15
s.cron '15 15 * * 0' do

  Rails.logger.info "Triggered weekly dispatching of ToDo emails"
  Rails.logger.flush
  SendWeekliesJob.perform_later
end