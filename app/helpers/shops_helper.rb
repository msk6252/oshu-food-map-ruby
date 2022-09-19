module ShopsHelper
  # 営業中・閉店などの判定
  def opening_text(shop)
    return "一時閉店" if shop.business_status == 2
    return "閉店" if shop.business_status == 3
    current_time = Time.now
    bh = shop.business_hour.where("? between started_at and finished_at", current_time)
    return bh.present? ? "営業中" : "準備中"
  end

  # お店のジャンルを抽出
  def shop_genre_names(shop)
    genre_names = []
    RelShopGenre.is_shop(shop.id).each do |rel|
      genre_names << Genre.find_by(id: rel.genre_id).try(:name)
    end
    genre_names
  end
end
