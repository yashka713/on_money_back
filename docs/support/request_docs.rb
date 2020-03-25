module Docs
  swagger_schema :RequestCreateCredentials do
    key :required, %i[request]
    property :request do
      key :type, :object
      key :properties,
        email: {
            type: :string,
            example: 'example@example.com'
        },
        description: {
            type: :string,
            example: 'Write here your question'
        },
        recover_password: {
            type: :integer,
            example: 1
        }
    end
  end
end
