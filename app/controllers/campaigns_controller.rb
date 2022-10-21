class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.all.order(:id)
  end

  def show  
  end
end
