module Api
  module V1
    class RequestsController < ::ApplicationController
      def create
        request = Request.new(request_params)
        return render_success({}, 201) if request.process

        render_jsonapi_errors request
      end

      private

      def request_params
        params.require(:request).permit(:description, :email, :recover_password)
      end
    end
  end
end
