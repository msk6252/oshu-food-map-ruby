require_relative '../models/timeframe'

class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    if current_admin
      admin_shops_path
    else
      new_admin_session_path
    end
  end
end
