module Docs
  swagger_schema :Unauthorized do
    key :type, :object
    property :errors do
      key :type, :array
      items do
        property :detail, type: :string, example: 'Unauthorized'
        property :source, type: :object do
          property :pointer, type: :string, example: 'unauthorized'
        end
      end
    end
  end
  swagger_schema :NotFound do
    key :type, :object
    property :errors do
      key :type, :array
      items do
        property :detail, type: :string, example: 'Not Found'
        property :source, type: :object do
          property :pointer, type: :string, example: 'not_found'
        end
      end
    end
  end
  swagger_schema :UnprocessableEntity do
    key :type, :object
    property :errors do
      key :type, :array
      items do
        property :detail, type: :string, example: I18n.t('activerecord.errors.models.user.attributes.password.blank')
        property :source, type: :object do
          property :pointer, type: :string, example: '/data/attributes/base'
        end
      end
    end
  end
  swagger_schema :Forbidden do
    key :type, :object
    property :errors do
      key :type, :array
      items do
        property :detail, type: :string, example: I18n.t('user.forbidden')
        property :source, type: :object do
          property :pointer, type: :string, example: 'forbidden'
        end
      end
    end
  end
end
