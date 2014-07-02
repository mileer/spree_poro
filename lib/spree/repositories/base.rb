module Spree
  class BaseRepository
    def self.store(object)
      object.id = redis.incr("#{base_key}:id")
      redis.set("#{base_key}:#{object.id}", serialize(object))
    end

    def self.get(id)
      attrs = JSON.parse(redis.get("#{base_key}:#{id}"))
      Object.const_get(base_class_name).new(attrs)
    end

    def self.redis
      @redis ||= Redis.connect
    end

    private

    def self.serialize(object)
      object.active_model_serializer.new(object).as_json.to_json
    end

    def self.base_key
      Inflecto.pluralize(self.base_class_name.split("::").last.downcase)
    end

    def self.base_class_name
      self.name.gsub("Repository", '')
    end
  end
end
