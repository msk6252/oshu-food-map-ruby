class DayOfWeek
  include ActiveModel::Model
  include ActiveModel::Attributes

  def self.all
    {
      "1": "月",
      "2": "火",
      "3": "水",
      "4": "木",
      "5": "金",
      "6": "土",
      "7": "日"
    }
  end
end

