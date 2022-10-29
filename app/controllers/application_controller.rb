class ApplicationController < ActionController::Base
  after_action :create_log_access
  rescue_from StandardError do |exception|
    create_log_access(exception)
  end

  def after_sign_in_path_for(resource)
    if current_admin
      admin_shops_path
    else
      new_admin_session_path
    end
  end

  def create_log_access(exception)
    error_message = exception.present? ? exception : ""
    parameters = request.request_method == "GET" ? request.query_parameters : request.request_parameters

    LogAccess.create!(
      url: request.path,
      http_method: request.request_method,
      parameters: parameters,
      referer: request.referer,
      user_agent: request.headers["HTTP_USER_AGENT"],
      ip_address: request.remote_ip,
      controller: controller_name,
      action: action_name,
      error_message: error_message
    )
  rescue => e
    Rails.logger.error("LogAccess Create Failed: #{e}")
  end
end
