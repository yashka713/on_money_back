module Api
  module V1
    class DocsController < ::ApplicationController
      include Swagger::Blocks

      def index
        render json: Docs.render_api(request.host_with_port, :v1)
      end
    end
  end
end
