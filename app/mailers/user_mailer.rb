class UserMailer < Devise::Mailer
  helper :application
  default template_path: 'devise/mailer'
end
