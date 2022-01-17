class Api::UsersController < ApplicationController
  before_action :authorized, only: [:user]

  # REGISTER
  def create
    @user = User.create(user_params)
    if @user.valid?
      token = encode_token({user_id: @user.id})
      render json: {user: @user.as_public_json, token: token}
    else
      render json: {error: "Failed to create user"}
    end
  end

  # LOGGING IN
  def login
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      token = encode_token({user_id: @user.id})
      render json: {user: @user.as_public_json, token: token}
    else
      render json: {error: "Invalid username or password"}
    end
  end


  def user
    render json: @user.as_public_json
  end

  private

  def user_params
    params.permit(:email, :password)
  end

end
