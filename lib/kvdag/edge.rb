class KVDAG
  # An edge to a vertex in a KVDAG

  class Edge
    include AttributeNode

    # Return the target vertex of this edge

    attr_reader :to_vertex

    # Create a new edge towards a vertex in a KVDAG,
    # optionally loaded with key-values
    #
    # N.B: KVDAG::Edge.new should never be called directly,
    # always use KVDAG::Vertex#edge to create edges.

    private :initialize
    def initialize(dag, target, attrs = {})
      @to_vertex = target
      @attrs = dag.hash_proxy_class.new(attrs)
    end

    def inspect
      '#<%s @attr=%s @to_vertex=%s>' % [self.class, @attrs.to_hash, @to_vertex]
    end

    alias to_s inspect

    # Return the proxied key-value hash tree visible from this edge
    # via its target vertex and all its ancestors
    #
    # Calling to_hash instead will return a regular hash tree, without
    # any special properties, e.g. for serializing as YAML or JSON.

    def to_hash_proxy
      result = @to_vertex.to_hash_proxy
      result.merge!(@attrs)
    end

    # Is the +target+ vertex reachable via this edge?

    def reachable?(target)
      @to_vertex.equal?(target) || @to_vertex.reachable?(target)
    end
  end
end
