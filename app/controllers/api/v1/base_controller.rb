module Api
  module V1
    class BaseController < ::ApplicationController
      include JsonApi
      include Authenticatable

      before_action :authenticate
    end
  end
end
