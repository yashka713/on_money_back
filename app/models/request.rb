class Request < ApplicationRecord
  attr_accessor :recover_password
  validates :email, presence: true

  def process
    send_new_password if need_password_recover?

    save
  end

  private

  def need_password_recover?
    recover_password == 1
  end

  def send_new_password
    user = User.find_by(email: email)

    user&.reset_password

    description << "\n There is problem with user. Write him!" if description.present?
  end
end
