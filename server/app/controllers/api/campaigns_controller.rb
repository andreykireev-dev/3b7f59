class Api::CampaignsController < ApplicationController
  def show
    offset, limit = parse_pagination_params params[:page], params[:page_size]
    campaigns = Campaign.where(user_id: @user.id).offset(offset).limit(limit)
    total = Campaign.where(user_id: @user.id).count
    render json: {campaigns: campaigns, size: campaigns.length, total: total}
  end

  def search
    query_text = params.require(:query)

    campaigns = Campaign
      .where(user_id: @user.id)
      .where(["name LIKE :query_text", {query_text: "%#{query_text}%"}])
      .limit(10)
  
    render json: campaigns
  end

  def create
    render json: Campaign.create({
      **campaign_params,
      user_id: @user.id,
    })
  end

  def add_prospects
    campaign = Campaign.find(params.require(:id))

    if campaign.user_id != @user.id
      return render status: 403, json: {message: "The campaign does not belong to this user."}
    end

    prospect_ids = params.require(:prospect_ids)

    # Exclude existing prospects.
    prospect_ids -= campaign.prospect_ids

    prospects = Prospect.find(prospect_ids)
    campaign.prospects << prospects

    return render json: {prospect_ids: prospect_ids}
  end

  def campaign_params
    params.permit(:name)
  end
end
