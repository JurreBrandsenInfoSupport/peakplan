module JwtAuthHelper
  def auth_header_for_user(user_id = 'test_user')
    payload = { sub: user_id, exp: Time.now.to_i + 86400 }
    # For tests, use a fixed secret key
    secret_key = 'test_secret'
    token = JWT.encode(payload, secret_key, 'HS256')
    { 'Authorization' => "Bearer #{token}" }
  end

  def setup_authenticated_header(user_id = 'test_user')
    request.headers.merge!(auth_header_for_user(user_id))
    # Allow Rails to decode with our test secret
    allow(Rails.application.credentials).to receive(:secret_key_base).and_return('test_secret')
  end
end

RSpec.configure do |config|
  config.include JwtAuthHelper, type: :controller
end
