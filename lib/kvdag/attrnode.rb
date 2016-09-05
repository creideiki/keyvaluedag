class KVDAG
  module AttributeNode
    attr_reader :attrs

    def fetch(attr, options = {})
      case
      when (options[:shallow])
        @attrs.fetch(attr)
      when self.respond_to?(:to_hash_proxy)
        to_hash_proxy.fetch(attr)
      else
        to_hash.fetch(attr)
      end
    end

    def [](attr, options = {})
      fetch(attr, options)
    rescue
      nil
    end

    def []=(attr, value)
      @attrs[attr] = value
    end

    def to_hash
      if self.respond_to?(:to_hash_proxy) then
        to_hash_proxy.to_hash
      else
        @attrs
      end
    end

    def merge!(other)
      @attrs.merge!(other.to_hash)
      self
    end
  end
end
