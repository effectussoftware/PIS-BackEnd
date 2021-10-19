class ApplicationController < ActionController::Base
  include Pundit
  after_action :verify_authorized,
               except: :index,
               unless: -> { :devise_controller? || :active_admin_controller? }
  after_action :verify_policy_scoped,
               only: :index,
               unless: -> { :devise_controller? || :active_admin_controller? }
  before_action :set_locale
  # Prevent CSRF attacks by raising an exception.
  # protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :json_request?
  def json_request?
    request.format.json?
  end

  def active_admin_controller?
    is_a?(ActiveAdmin::BaseController)
  end

  private

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = request.headers['locale']
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
