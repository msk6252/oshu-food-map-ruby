module ShopsHelper
  def opening_text(shop)
    return "一時閉店" if shop.business_status == 2
    return "閉店" if shop.business_status == 3
    current_time = Time.now
    bh = shop.business_hour.where("? between started_at and finished_at", current_time)
    return  bh.present? ? "営業中" : "準備中"
  end
end
