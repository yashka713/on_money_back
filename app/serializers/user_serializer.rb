class UserSerializer < ActiveModel::Serializer
  attributes(*User.attribute_names.map(&:to_sym) - %i[
    password_digest created_at updated_at
  ])

  attribute :jwt, if: :current_user?

  def current_user?
    @scope.nil? || @object.id == @scope.id
  end

  def jwt
    Auth.issue(@object.id)
  end
end
