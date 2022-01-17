class Api::ProspectsController < ApplicationController
  def show
    offset, limit = parse_pagination_params params[:page], params[:page_size]
    prospects = Prospect.where(user_id: @user.id).offset(offset).limit(limit)
    total = Prospect.where(user_id: @user.id).count
    render json: {prospects: prospects, size: prospects.length, total: total}
  end

  def create
    render json: Prospect.create({
      **prospect_params,
      user_id: @user.id,
    })
  end

  def prospect_params
    params.permit(:email, :first_name, :last_name)
  end
end
