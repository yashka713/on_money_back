class Request < ApplicationRecord
  attr_accessor :recover_password
  validates :email, presence: true

  def process
    return send_new_password if need_password_recover?

    Rails.logger.info '-----------------------Support requested---------------'
    save
  end

  private

  def need_password_recover?
    recover_password == 1
  end

  def send_new_password
    user = User.find_by(email: email)

    user&.reset_password

    Rails.logger.info '-----------------------mail sent---------------'

    description << "\n There is problem with user. Write him!"
    save
  end
end
