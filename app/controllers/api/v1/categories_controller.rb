module Api
  module V1
    class CategoriesController < BaseController
      before_action :set_category, only: %i[show update]

      def index
        categories = if params[:type_of]
                       Category.public_send(params[:type_of], current_user)
                     else
                       current_user.categories
                     end

        render_success categories
      end

      def create
        category = current_user.categories.new(create_category_params)
        if category.save
          render_success category, 201
        else
          render_jsonapi_errors category
        end
      end

      def show
        render_success @category
      end

      def update
        if @category.update(update_category_params)
          render_success @category
        else
          render_jsonapi_errors @category
        end
      end

      def types
        types = {
          data: ActiveModel::Serializer::CollectionSerializer.new(Category::TYPES,
                                                                  serializer: CategoryTypeSerializer)
        }
        render_success types
      end

      private

      def create_category_params
        params.require(:category).permit(:name, :note, :type_of)
      end

      def update_category_params
        params.require(:category).permit(:name, :note)
      end

      def set_category
        @category = Category.find(params[:id])
      end
    end
  end
end
