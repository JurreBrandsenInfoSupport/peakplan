class ApplicationController < ActionController::API
  private

  def current_user
    # Under production circumstances, this would return a user model based on an incoming JWT.
    # For the purpose of my tests, I don't care what is returned here. Might come back and
    # fix this :-)
    "test_user"
  end
end
