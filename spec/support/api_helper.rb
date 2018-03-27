module ApiHelper
  def signup(registration, status = :ok)
    post user_registration_path, params: registration
    expect(response).to have_http_status(status)
    payload = JSON.parse(response.body)
    if response.ok?
      registration.merge(:id => payload['data']['id'], :uid => payload['data']['uid'])
    end
  end

  def login(credentials, status=:ok)
    post user_session_path, params: credentials
    expect(response).to have_http_status(status)
  end

  def logout(headers, status=:ok)
    delete destroy_user_session_path, headers: headers
    @last_tokens={}
    expect(response).to have_http_status(status) if status
  end

  def access_tokens?
    !response.headers["access-token"].nil?  if response
  end

  def access_tokens
    if access_tokens?
      @last_tokens=["uid","client","token-type","access-token"].inject({}) {|h,k| h[k]=response.headers[k]; h}
    end
    @last_tokens || {}
  end

  def get_cred(response)
    response.headers.slice('access-token', 'token-type', 'client', 'expiry', 'uid')
  end
end
