module Api
  module V1
    class BaseController < ::ApplicationController
      include JsonApi
    end
  end
end
