module Api
  module V1
    class ApiController < ActionController::API
      include Api::Concerns::ActAsApiRequest
      include Pundit
      include DeviseTokenAuth::Concerns::SetUserByToken

      before_action :authenticate_user!, except: :status
      before_action :set_locale

      respond_to :json

      rescue_from ActiveRecord::RecordNotFound,        with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid,         with: :render_record_invalid
      rescue_from ActionController::ParameterMissing,  with: :render_parameter_missing

      def status
        render json: { online: true }
      end

      private

      def set_locale
        I18n.locale = extract_locale || I18n.default_locale
      end

      def extract_locale
        parsed_locale = request.headers['locale']
        I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
      end

      def render_not_found(exception)
        logger.info { exception } # for logging
        render json: { error: I18n.t('api.errors.not_found') }, status: :not_found
      end

      def render_record_invalid(exception)
        logger.info { exception } # for logging
        render json: { errors: exception.record.errors.as_json }, status: :bad_request
      end

      def render_parameter_missing(exception)
        logger.info { exception } # for logging
        render json: { error: I18n.t('api.errors.missing_param') }, status: :unprocessable_entity
      end
    end
  end
end

# FIXME: Agregados para evitar missing translations
# FIXME: remover a medida que se vayan agregando
# i18n-tasks-use t('errors.messages.blank')
# i18n-tasks-use t('errors.messages.accepted')
# i18n-tasks-use t('errors.messages.confirmation')
# i18n-tasks-use t('errors.messages.empty')
# i18n-tasks-use t('errors.messages.equal_to')
# i18n-tasks-use t('errors.messages.even')
# i18n-tasks-use t('errors.messages.exclusion')
# i18n-tasks-use t('errors.messages.greater_than')
# i18n-tasks-use t('errors.messages.greater_than_or_equal_to')
# i18n-tasks-use t('errors.messages.inclusion')
# i18n-tasks-use t('errors.messages.invalid')
# i18n-tasks-use t('errors.messages.less_than')
# i18n-tasks-use t('errors.messages.less_than_or_equal_to')
# i18n-tasks-use t('errors.messages.model_invalid')
# i18n-tasks-use t('errors.messages.not_a_number')
# i18n-tasks-use t('errors.messages.not_an_integer')
# i18n-tasks-use t('errors.messages.odd')
# i18n-tasks-use t('errors.messages.other_than')
# i18n-tasks-use t('errors.messages.present')
# i18n-tasks-use t('errors.messages.required')
# i18n-tasks-use t('errors.messages.taken')
# i18n-tasks-use t('errors.messages.too_long')
# i18n-tasks-use t('errors.messages.too_short')
# i18n-tasks-use t('errors.messages.wrong_length')
# i18n-tasks-use t('errors.support.array.last_word_connector')
# i18n-tasks-use t('errors.support.array.two_words_connector')
# i18n-tasks-use t('errors.support.array.words_connector')
# i18n-tasks-use t('errors.messages.empty')
# i18n-tasks-use t('errors.messages.equal_to')
# i18n-tasks-use t('errors.messages.even')
# i18n-tasks-use t('errors.messages.exclusion')
# i18n-tasks-use t('errors.messages.greater_than')
# i18n-tasks-use t('errors.messages.greater_than_or_equal_to')
# i18n-tasks-use t('errors.messages.inclusion')
# i18n-tasks-use t('errors.messages.invalid')
# i18n-tasks-use t('errors.messages.less_than')
# i18n-tasks-use t('errors.messages.less_than_or_equal_to')
# i18n-tasks-use t('errors.messages.model_invalid')
# i18n-tasks-use t('errors.messages.not_a_number')
# i18n-tasks-use t('errors.messages.not_an_integer')
# i18n-tasks-use t('errors.messages.odd')
# i18n-tasks-use t('errors.messages.other_than')
# i18n-tasks-use t('errors.messages.present')
# i18n-tasks-use t('errors.messages.required')
# i18n-tasks-use t('errors.messages.taken')
# i18n-tasks-use t('errors.messages.too_long')
# i18n-tasks-use t('errors.messages.too_short')
# i18n-tasks-use t('errors.messages.wrong_length')
# i18n-tasks-use t('errors.support.array.last_word_connector')
# i18n-tasks-use t('errors.support.array.two_words_connector')
# i18n-tasks-use t('errors.support.array.words_connector')
