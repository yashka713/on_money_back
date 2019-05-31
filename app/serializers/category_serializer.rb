class CategorySerializer < ActiveModel::Serializer
  attributes(*Category.attribute_names.map(&:to_sym) - %i[
    user_id
  ])
end
