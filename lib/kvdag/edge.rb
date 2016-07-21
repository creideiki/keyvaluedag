class KVDAG
  class Edge
    include AttributeNode
    attr_reader :to_vertex

    private :initialize
    def initialize(dag, target, attrs = {})
      @to_vertex = target
      @attrs = dag.hash_proxy_class.new(attrs)
    end

    def inspect
      "#<%s @attr=%s @to_vertex=%s>" % [self.class, @attrs.to_hash, @to_vertex]
    end

    alias to_s inspect

    def to_hash_proxy
      result = @to_vertex.to_hash_proxy
      result.merge!(@attrs)
    end

    def reachable?(target)
      @to_vertex.equal?(target) || @to_vertex.reachable?(target)
    end
  end
end
