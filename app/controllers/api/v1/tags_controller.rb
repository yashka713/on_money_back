module Api
  module V1
    class TagsController < BaseController
      load_and_authorize_resource :tag, except: %i[index create]

      def index
        render_success current_user.tags
      end

      def create
        tag = current_user.tags.find_or_create_by(tag_params)

        return render_success(tag, 200) if tag.persisted?

        render_jsonapi_errors tag
      rescue ActiveRecord::RecordNotUnique
        retry
      end

      def show
        render_success @tag
      end

      def update
        if @tag.update(tag_params)
          render_success @tag
        else
          render_jsonapi_errors @tag
        end
      end

      def destroy
        return render_success {} if @tag.destroy

        render_jsonapi_errors @tag
      end

      private

      def tag_params
        params.require(:tag).permit(:name)
      end
    end
  end
end
