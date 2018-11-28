require_dependency 'lit/application_controller'

module Lit
  class DashboardController < ::Lit::ApplicationController
    def index
      @total_localization_kyes = Lit::LocalizationKey.count(:id)
      @locales = Lit::Locale.ordered.visible.includes(:localizations)
    end
  end
end
