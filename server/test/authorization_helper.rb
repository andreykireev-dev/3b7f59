module AuthorizationHelper
  # def sign_up(user)
  #   # The argument 'user' should be a hash that includes the params 'email' and 'password'.
  #   post '/auth/',
  #     params: { email: user[:email],
  #               password: user[:password],
  #               password_confirmation: user[:password] },
  #     as: :json
  # end

  def auth_tokens_for_user(user)
    # The argument 'user' should be a hash that includes the params 'email' and 'password'.

    # byebug

    # host! 'localhost:3001'

    post "http://localhost:3001/api/login", params: {email: user[:email], password: user[:password]},       as: :json

    # The three categories below are the ones you need as authentication headers.
    
    # response.headers.slice('client', 'access-token', 'uid')
    return JSON.parse(response.body)["token"]

  end
end