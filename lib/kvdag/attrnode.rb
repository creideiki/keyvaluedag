class KVDAG
  module AttributeNode
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
