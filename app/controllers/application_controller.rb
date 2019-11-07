class ApplicationController < ActionController::API
  before_action :authenticate_jwt

  def get_jwt_token
    @jwt_token ||= request.headers.env["HTTP_AUTHORIZATION"]
  end

  def jwt_info
    @jwt_info ||= JsonWebToken.decode(get_jwt_token)
  end

  def jwt_info_valid?
    jwt_info.present? && jwt_info['scope'].include?(required_scope)
  end

  def required_scope
    raise RuntimeError # Not Defined
  end

  def authenticate_jwt
    jwt_info_valid? || render_unauthorized
  end


  #pagination info for kimiari
  def page_param
    if params[:page].is_a? ActionController::Parameters
      params[:page][:number]
    else
      params[:page]
    end
  end

  def per_page_param
    if params[:page].is_a? ActionController::Parameters
      params[:page][:size]
    else
      params[:per_page]
    end
  end

  def required_permission
    self.class.permissions[action_name]
  end

  def self.permissions
    @permissions ||= {
        'index' => 'read',
        'show' => 'read',
        'update' => 'write'
    }
  end

  def current_client
    @current_client ||= Client.find_by(uuid: jwt_info['client']['uuid']) if jwt_info_valid? && jwt_info['client']['uuid'].present?
  end

  def render_unauthorized
    render_json_api_error("401", "Not Authorized", "Need api scope: #{required_scope}")
  end

  def render_json_api_error(status, title, detail, source = {})
    render json: {
        "errors": [
            {
                "status": status,
                "source": source,
                "title": title,
                "detail": detail
            }
        ]}, status: status
  end

end
