DEFAULT_PAGE = 0
MIN_PAGE = 0
DEFAULT_PAGE_SIZE = 10
MIN_PAGE_SIZE = 1
MAX_PAGE_SIZE = 100

class ApplicationController < ActionController::API
  before_action :authorized

  def encode_token(payload)
    # TODO change secret key to environment variable
    JWT.encode(payload, 's3cr3t')
  end

  def auth_header
    # { Authorization: 'Bearer <token>' }
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      # header: { 'Authorization': 'Bearer <token>' }
      begin
        JWT.decode(token, 's3cr3t', true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def logged_in_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!logged_in_user
  end

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end

  def parse_pagination_params(page, page_size)
    page = (page || DEFAULT_PAGE).to_i
    if page < MIN_PAGE
      page = MIN_PAGE
    end

    page_size = (page_size || DEFAULT_PAGE_SIZE).to_i
    if page_size < MIN_PAGE_SIZE
      page_size = MIN_PAGE_SIZE
    elsif page_size > MAX_PAGE_SIZE
      page_size = MAX_PAGE_SIZE
    end

    offset = page_size * page

    return [offset, page_size]
  end
end
