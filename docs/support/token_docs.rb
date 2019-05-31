module Docs
  swagger_schema :TokenParam do
    key :name, :Authorization
    key :in, :header
    key :description, 'Authentication token for user access'
    key :type, :string
    key :required, true
  end

  swagger_schema :TokenExample do
    key :type, :string
    key :example, 'Bearer JWT_token'
  end
end
