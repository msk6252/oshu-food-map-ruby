class ApplicationController < ActionController::Base
  after_action :create_log_access
  before_action :basic_auth, if: proc { Rails.env.production? }

  rescue_from StandardError do |exception|
    create_log_access(exception)
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_USER_NAME"] && password == ENV["BASIC_PASSWORD"]
    end
  end

  def after_sign_in_path_for(resource)
    if current_admin
      admin_shops_path
    else
      new_admin_session_path
    end
  end

  def create_log_access(exception = "")
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
      error_message: exception
    )
  rescue => e
    Rails.logger.error("LogAccess Create Failed: #{e}")
  end
end
