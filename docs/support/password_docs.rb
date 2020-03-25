module Docs
  swagger_schema :UpdatePasswordCredentials do
    key :required, %i[change_password]
    property :change_password do
      key :type, :object
      key :properties,
          old_password: {
              type: :string,
              example: 'Passw1'
          },
          new_password: {
              type: :string,
              example: 'Passw2'
          },
          new_password_confirmation: {
              type: :string,
              example: 'Passw2'
          }
    end
  end
end
