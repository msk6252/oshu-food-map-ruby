class Admin::ShopsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_shop, only: %i[ show edit update destroy revival ]

  DEFAULT_PAGE = 30

  # GET /admin/shops or /admin/shops.json
  def index
    @shops = Shop.all.page(params[:page]).per(DEFAULT_PAGE)
    @shops = @shops.where("name like ?", "%#{params[:kw]}%") if params[:kw].present?
  end

  # GET /admin/shops/1 or /admin/shops/1.json
  def show
  end

  # GET /admin/shops/new
  def new
    @shop = Shop.new
  end

  # GET /admin/shops/1/edit
  def edit
  end

  # POST /admin/shops or /admin/shops.json
  def create
    @shop = Shop.new(shop_params)

    # 画像を更新
    if shop_params[:cooking_images].present?
      @shop.cooking_images.each do |image|
        image.purge
      end
    end

    respond_to do |format|
      if @shop.save!
        format.html { redirect_to admin_shop_path(@shop), notice: "Shop was successfully created." }
        format.json { render :show, status: :created, location: @shop }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/shops/1 or /admin/shops/1.json
  def update
    shop_params_hash = shop_params.to_h
    # 公開状況をBooleanに変換
    shop_params_hash["public"] = shop_params_hash["public"].to_i == 1 ? true : false
    # POSTされたジャンル一覧から0を省く
    shop_params_hash["genre_ids"] = shop_params_hash["genre_ids"] - ["0"]

    puts "+++++++++++++++"
    puts "+++++++++++++++"
    puts shop_params_hash["genre_ids"]
    puts "+++++++++++++++"
    puts "+++++++++++++++"
    
    ActiveRecord::Base.transaction do
      # 画像を更新
      if shop_params_hash[:cooking_images].present?
        @shop.cooking_images.each do |image|
          image.purge
        end
      end


      respond_to do |format|
        if @shop.update!(shop_params_hash)
          format.html { redirect_to admin_shop_path(@shop), notice: "Shop was successfully updated." }
          format.json { render :show, status: :created, location: @shop }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @shop.errors, status: :unprocessable_entity }
        end
      end
    rescue => e
      Rails.logger.error{ "Error: #{e}"}
    end
  end

  # DELETE /admin/shops/1 or /admin/shops/1.json
  def destroy
    # 論理削除
    respond_to do |format|
      if @shop.discard
        format.json { render json: :nil, status: :ok }
      else
        format.json { render json: :nil, status: :internal_server_error }
      end
    end
  end

  def revival
    respond_to do |format|
      if @shop.undiscard
        format.json { render json: :nil, status: :ok }
      else
        format.json { render json: :nil, status: :internal_server_error }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop
      @shop = Shop.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shop_params
      params.require(:shop).permit(:name, :latitude, :longitude, :address, :tel, :inside_image, :outside_image, :public, cooking_images: [], genre_ids: [])
    end
end
