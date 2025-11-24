Devise.setup do |config|
  # The e-mail address shown in Devise::Mailer
  config.mailer_sender = "please-change-me@example.com"

  # Use ActiveRecord as ORM
  require "devise/orm/active_record"

  # Keys treated as case-insensitive and stripped of whitespace
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]

  # Skip session storage for HTTP auth
  config.skip_session_storage = [:http_auth]

  # BCrypt cost
  config.stretches = Rails.env.test? ? 1 : 12

  # Rememberable
  # config.remember_for = 2.weeks

  # Validatable
  config.password_length = 6..128

  # Reset password
  config.reset_password_within = 6.hours

  # HTTP verb used to sign out
  config.sign_out_via = :delete

  # Turbo integration (Rails 7+/8)
  config.navigational_formats = ["*/*", :html, :turbo_stream]
end
