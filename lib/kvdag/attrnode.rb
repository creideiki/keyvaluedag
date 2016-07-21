class KVDAG
  module AttributeNode
    attr_reader :attrs

    def [](attr)
      @attrs[attr]
    end

    def []=(attr, value)
      @attrs[attr] = value
    end

    def to_hash
      @attrs
    end
  end
end
