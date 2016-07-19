class KVDAG
  class Edge
    include AttributeNode
    attr_reader :to_vertex

    private :initialize
    def initialize(target, attrs = {})
      @to_vertex = target
      @attrs = attrs
    end

    def [](attr)
      @attrs[attr] || to_vertex[attr]
    end

    def to_hash
      result = @to_vertex.to_hash
      result.merge!(@attrs)
    end

    def reachable?(target)
      @to_vertex.equal?(target) || @to_vertex.reachable?(target)
    end
  end
end
