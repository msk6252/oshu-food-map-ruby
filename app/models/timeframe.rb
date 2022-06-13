class TimeFrame
  include ActiveModel::Model
  include ActiveModel::Attributes

  def self.all
    {
      "1": { started_at: '05:00', finished_at: '07:00' },
      "2": { started_at: '07:00', finished_at: '11:00' },
      "3": { started_at: '11:00', finished_at: '15:00' },
      "4": { started_at: '15:00', finished_at: '18:00' },
      "5": { started_at: '18:00', finished_at: '23:00' },
      "6": { started_at: '23:00', finished_at: '05:00' }
    }
  end
end

