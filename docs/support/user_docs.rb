module Docs
  swagger_schema :UserCredentials do
    key :required, %i[user]
    property :user do
      key :type, :object
      key :properties,
          email: {
            type: :string,
            example: 'email@example.com'
          },
          password: {
            type: :string,
            example: 'Passw1'
          }
    end
  end

  swagger_schema :ProfileItem do
    key :type, :object
    property :id do
      key :type, :string
      key :example, '0'
    end
    property :type do
      key :type, :string
      key :example, 'users'
    end
    property :attributes do
      key :type, :object
      property :name do
        key :type, :string
        key :example, 'User name'
      end
      property :nickname do
        key :type, :string
        key :example, 'User nickname'
      end
      property :email do
        key :type, :string
        key :example, 'email@example.com'
      end
      property :jwt do
        key :type, :string
        key :example, 'JWT_token'
      end
    end
  end
end
