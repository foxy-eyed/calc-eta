# frozen_string_literal: true

class RedisCache
  DEFAULT_REDIS_URL = "redis://127.0.0.1:6379"
  DB_KEY = 1

  attr_reader :expires_in, :key_prefix

  def initialize(expires_in: nil, key_prefix: nil)
    @expires_in = expires_in
    @key_prefix = key_prefix
  end

  def read(key)
    redis.get(inner_key(key))
  end

  def write(key, value)
    redis.set(inner_key(key), value, ex: expires_in)
  end

  def exists?(key)
    redis.exists?(inner_key(key))
  end

  def delete(key)
    redis.del(inner_key(key))
  end

  def fetch(key, &block)
    value = read(key)
    if value.nil? && block_given?
      value = block.call
      write(key, value)
    end
    value
  end

  def reset!
    raise "Non-fake storage cannot be reset!" unless self.class.fake

    redis.flushdb
  end

  class << self
    attr_reader :fake

    def fake!
      @fake = true
    end
  end

  private

  def redis
    @redis ||= if self.class.fake
                 MockRedis.new
               else
                 Redis.new(url: ENV.fetch("REDIS_URL", DEFAULT_REDIS_URL), db: DB_KEY)
               end
  end

  def inner_key(key)
    [key_prefix, key].compact.join(":")
  end
end
