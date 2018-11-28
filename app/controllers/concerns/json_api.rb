module JsonApi
  extend ActiveSupport::Concern

  def render_success(object = {}, code = 200, options = {})
    return render status: code if object.nil?

    render json: object, status: code, include: options[:include], serializer: options[:serializer]
    false
  end

  def render_jsonapi_errors(resource, code = 422)
    render json: resource, serializer: ActiveModel::Serializer::ErrorSerializer, status: code
    false
  end

  def render_400(body)
    render json: to_jsonapi_errors(
      'bad_request',
      body
    ), status: 400
    false
  end

  def render_401(message = 'Unauthorized')
    render json: to_jsonapi_errors('unauthorized', message), status: 401

    false
  end

  def render_403(message = I18n.t('user.forbidden'))
    render json: to_jsonapi_errors(
      'forbidden',
      message
    ), status: 403
    false
  end

  def render_404
    render json: to_jsonapi_errors(
      'not_found',
      'Not Found'
    ), status: 404
    false
  end

  private

  def to_jsonapi_errors(source, message)
    { errors: [{ source: { pointer: source }, detail: message }] }
  end
end
