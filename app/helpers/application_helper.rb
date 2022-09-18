module ApplicationHelper

  # 指定した画像のタグを生成
  # 画像がない または 画像が指定されていない場合、placeholdが返却
  def get_image_tag(img="", width=150, height=150, cls="")
    # 画像が指定されていない場合
    return "<img src='https://placehold.jp/#{width}x#{height}.png' #{"class=#{cls}" if cls.present?} />".html_safe if img.blank?

    return image_tag(img, class: cls, width: "#{width}px", height: "#{height}px") if img.kind_of?(String)

    # 画像がない場合
    return "<img src='https://placehold.jp/#{width}x#{height}.png' #{"class=#{cls}" if cls.present?} />".html_safe if !img.attached?

    return image_tag(img, class: cls, width: "#{width}px", height: "#{height}px")
  end
end
