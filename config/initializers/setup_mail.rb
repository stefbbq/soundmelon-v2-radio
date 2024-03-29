ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => ENV['HOST_ADDR'] + ':80',
  :user_name						=> ENV['HELLO_EMAIL'],
  :password							=> ENV['HELLO_PASSWORD'],
  # :user_name            => "miniflckr.mailer@gmail.com",
  # :password             => "awesomesauce",
  :authentication       => :plain,
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = ENV['HOST_ADDR'].split('http://')[1]
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
