def response_errors
  return [] if response.body.blank?

  @response_errors ||= JSON.parse(response.body)['errors']
end

def parsed_response_body
  response.body.blank? ? '' : JSON.parse(response.body)
end

def parsed_body(body = response.body)
  JSON.parse(body)
end

def parsed_data_from_body(body = response.body)
  parsed_body(body)['data']
end

def parsed_id(hash)
  hash.map { |e| e['id'].to_i }
end

def login_user(user)
  jwt = Auth.issue(user.id)
  request.headers['Authorization'] = "Bearer #{jwt}"
end
