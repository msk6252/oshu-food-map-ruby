class Admin::ShopsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_shop, only: %i[ show edit update destroy ]

  # GET /admin/shops or /admin/shops.json
  def index
    @shops = Shop.all
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

    respond_to do |format|
      if @shop.save
        format.html { redirect_to admin_shops_path, notice: "Shop was successfully created." }
        format.json { render :show, status: :created, location: @shop }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/shops/1 or /admin/shops/1.json
  def update
    respond_to do |format|
      if shop_params[:cooking_images]&.length > 0
        @shop.cooking_images.each do |image|
          image.purge
        end
      end
      if @shop.update(shop_params)
        format.html { redirect_to admin_shops_path, notice: "Shop was successfully updated." }
        format.json { render :show, status: :ok, location: @shop }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/shops/1 or /admin/shops/1.json
  def destroy
    @shop.discard
    @shop.outside_image.purge if @shop.outside_image.attached?
    @shop.inside_image.purge  if @shop.inside_image.attached?
    @shop.cooking_images.each do |img|
      img.purge
    end
    respond_to do |format|
      format.html { redirect_to admin_shops_path, notice: "Shop was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop
      @shop = Shop.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shop_params
      params.require(:shop).permit(:name, :latitude, :longitude, :address, :inside_image, :outside_image, cooking_images: [])
    end
end
