class UserMailer < ApplicationMailer
  def reset_password_email(user, password)
    @user = user
    @password = password
    mail(to: @user.email, subject: 'Your password has been reset.')
  end
end
