module Docs
  extend self

  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'

    key :basePath, '/'
    key :produces, %w[application/json]
    key :consumes, %w[application/json]
    key :schemes, %w[https http]
    info do
      key :version, '1.0.0'
      key :title, 'An API for "On Money App"'
      key :description, 'An API for "On Money App"'
      contact do
        key :name, 'Liakh Yaaroslav'
      end
    end
  end

  def render_api(host, version)
    Swagger::Blocks.build_root_json(
      [api_schemes(version.to_s)]
    ).merge(host: host, info: { title: 'On Money API', version: version })
  end

  private

  def api_schemes(version)
    Dir.glob Rails.root.join('docs', 'controllers', 'api', version, '**', '*_docs.rb'), &method(:require)
    Dir.glob Rails.root.join('docs', 'models', '**', '*_docs.rb'), &method(:require)
    Dir.glob Rails.root.join('docs', 'support', '**', '*_docs.rb'), &method(:require)

    self
  end
end
