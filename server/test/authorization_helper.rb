module AuthorizationHelper
  def auth_tokens_for_user(user)
    # The argument 'user' should be a hash that includes the params 'email' and 'password'.
    post "http://localhost:3001/api/login", params: {email: user[:email], password: user[:password]},       as: :json

    return JSON.parse(response.body)["token"]

  end
end