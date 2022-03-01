# frozen_string_literal: true

module CalcEta
  class << self
    def cache
      @cache ||= RedisCache.new(expires_in: ENV.fetch("ETA_MAX_DEVIATION", 60), key_prefix: "eta")
    end
  end
end
