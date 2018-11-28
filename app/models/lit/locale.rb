module Lit
  class Locale < ActiveRecord::Base
    ## SCOPES
    scope :ordered, proc { order('locale ASC') }
    scope :visible, proc { where(is_hidden: false) }

    ## ASSOCIATIONS
    has_many :localizations, dependent: :destroy

    ## VALIDATIONS
    validates :locale,
              presence: true,
              uniqueness: true

    ## BEFORE & AFTER
    after_save :reset_available_locales_cache
    after_destroy :reset_available_locales_cache

    unless defined?(::ActionController::StrongParameters)
      ## ACCESSIBLE
      attr_accessible :locale
    end

    def to_s
      locale
    end

    def get_translated_percentage
      return 0 unless get_all_localizations_count > 0
      (get_changed_localizations_count * 100) / get_all_localizations_count.to_f
    end

    def get_changed_localizations_count
      @_c_count ||= localizations.select(&:is_changed).size
    end

    def get_all_localizations_count
      @_count ||= localizations.size
    end

    private

    def reset_available_locales_cache
      return unless I18n.backend.respond_to?(:reset_available_locales_cache)
      I18n.backend.reset_available_locales_cache
    end
  end
end
