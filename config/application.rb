require_relative "boot"

require "rails"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GrocyRuby
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    Rails.application.config.active_storage.service = :local
  end
end

markdown_options = {
  tables: true,
  fenced_code_blocks: true,
  autolink: true,
  space_after_headers: true,
  superscript: true,
  underline: true,
  highlight: true,
  footnotes: true,
  quote: true
}

html_options = {
  hard_wrap: true
}

renderer = Redcarpet::Render::Safe.new(html_options)

$redcarpet_markdown = Redcarpet::Markdown.new(renderer, markdown_options)