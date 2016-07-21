class KVDAG
  module AttributeNode
    attr_reader :attrs

    def [](attr)
      if self.respond_to?(:to_hash_proxy) then
        to_hash_proxy[attr]
      else
        to_hash[attr]
      end
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
