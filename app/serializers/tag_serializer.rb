class TagSerializer < ActiveModel::Serializer
  attributes(*Tag.attribute_names.map(&:to_sym) - %i[user_id])
end
