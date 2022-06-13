class ShopsController < ApplicationController
  before_action :set_shop, only: %i[ show edit update destroy ]
  before_action :set_tab_title, only: [:index, :nearby, :anxious, :newer]

  DEFAULT_PAGE = 5

  # GET /shops or /shops.json
  def index
    @shops = Shop.all


    @shops = Shop.all.page(params[:page]).per(DEFAULT_PAGE)
    @shops_all = @shops
  end

  # GET /shops/1 or /shops/1.json
  def show
  end

  def nearby
    @shops_all = Shop.all
    @shops = Kaminari.paginate_array(Shop.distance_from_current_sortby(@shops_all)).page(params[:page]).per(DEFAULT_PAGE)
  end

  def anxious
    @shops = Shop.all.page(params[:page]).per(DEFAULT_PAGE)
    @shops_all = @shops
  end

  def newer
    @shops = Shop.all.page(params[:page]).per(DEFAULT_PAGE)
    @shops_all = @shops
  end

  def result
    @shops = Shop.all.active.published
    if params[:genre].present? &&
       params[:genre].to_i != 0
      @shops = @shops.eager_load(:rel_shop_genre).where(rel_shop_genres: { genre_id: params[:genre] })
    end

    if params[:timeframe].present?
      tf = TimeFrame.all
      timeframe = params[:timeframe].to_sym
      started_at = tf[timeframe][:started_at]
      finished_at = tf[timeframe][:finished_at]
      @shops = @shops.eager_load(:business_hour).where('started_at between ? and ?', started_at, finished_at).where('finished_at between ? and ?', started_at, finished_at)
    end

    if params[:lat].present? && params[:lng].present?
      @shops = Shop.distance_from_current_sortby(@shops, params[:lat].to_f, params[:lng].to_f)
    end

    @shops = Kaminari.paginate_array(@shops).page(params[:page]).per(DEFAULT_PAGE)
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

    def set_tab_title
      case action_name
      when "index"
        @tab_title = "おすすめのお店"
      when "nearby"
        @tab_title = "近くのお店"
      when "anxious"
        @tab_title = "気になるお店"
      when "newer"
        @tab_title = "新しいお店"
      end
    end
end
