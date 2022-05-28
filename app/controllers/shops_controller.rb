class ShopsController < ApplicationController
  before_action :set_shop, only: %i[ show edit update destroy ]

  DEFAULT_PAGE = 3

  # GET /shops or /shops.json
  def index
    @shops = Shop.all.page(params[:page]).per(DEFAULT_PAGE)
  end

  # GET /shops/1 or /shops/1.json
  def show
  end

  def get_nearby_shops
    return :no_content if params[:lat].blank? || params[:lon].blank? 


  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop
      @shop = Shop.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shop_params
      params.require(:shop).permit(:name, :latitude, :longitude, :address, :what_three_words)
    end
end
