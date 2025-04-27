class ApplicationController < ActionController::API
  before_action :require_authentication

  private

  def require_authentication
    unless valid_token
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def valid_token
    header = request.headers["Authorization"]
    return nil if header.blank?

    token = header.split(" ").last if header.start_with?("Bearer ")

    begin
      decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: "HS256" })
      decoded_token
    rescue JWT::DecodeError
      nil
    end
  end

  def current_user
    token = valid_token
    return nil unless token

    begin
      token.first["sub"]
    rescue JWT::DecodeError
      nil
    end
  end
end
