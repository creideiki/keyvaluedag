class KVDAG

  # A vertex in a KVDAG

  class Vertex
    include AttributeNode
    include Comparable
    attr_reader :dag
    attr_reader :edges

    # Create a new vertex in a KVDAG, optionally loaded
    # with key-values.
    #
    # N.B: KVDAG::Vertex.new should never be called directly,
    # always use KVDAG#vertex to create vertices.

    private :initialize
    def initialize(dag, attrs = {})
      @edges = Set.new
      @dag = dag
      @attrs = dag.hash_proxy_class.new(attrs)

      @dag.vertices << self
    end

    def inspect
      "#<%s @attr=%s @edges=%s>" % [self.class, @attrs.to_hash, @edges.to_a]
    end

    alias to_s inspect

    # Return the set of all direct parents

    alias parents edges

    # Return the set of all direct children

    def children
      result = Set.new
      dag.vertices.each do |vertex|
        next if vertex.equal?(self)
        vertex.edges.each do |edge|
          result << vertex if edge.to_vertex.equal?(self)
        end
      end
      result
    end

    # Is +other+ vertex reachable via any of my #edges?
    #
    # A KVDAG::VertexError is raised if vertices belong
    # to different KVDAG.

    def reachable?(other)
      other = other.to_vertex unless other.is_a?(Vertex)
      raise VertexError.new("Not in the same DAG") unless @dag.equal?(other.dag)
      
      equal?(other) || @edges.any? {|edge| edge.reachable?(other)}
    end

    # Am I reachable from +other+ via any of its #edges?
    #
    # A KVDAG::VertexError is raised if vertices belong
    # to different KVDAG.

    def reachable_from?(other)
      other.reachable?(self)
    end

    # Return the set of all parents, and their parents, recursively
    #
    # This is the same as all #reachable? vertices.

    def ancestors
      result = Set.new
      dag.vertices.each {|vertex| result << vertex if reachable?(vertex)}
      result
    end

    # Return the set of all children, and their children, recursively
    #
    # This is the same as all #reachable_from? vertices.

    def descendants
      result = Set.new
      dag.vertices.each {|vertex| result << vertex if reachable_from?(vertex)}
      result
    end

    # Comparable ordering for a DAG:
    #
    # Reachable vertices are lesser.
    # Unreachable vertices are equal.

    def <=>(other) 
      return -1 if reachable?(other)
      return 1 if reachable_from?(other)
      return 0
    end

    # Create an edge towards an +other+ vertex, optionally
    # loaded with key-values.
    #
    # A KVDAG::VertexError is raised if vertices belong
    # to different KVDAG.
    #
    # A KVDAG::CyclicError is raised if the edge would
    # cause a cycle in the KVDAG.

    def edge(other, attrs = {})
      other = other.to_vertex unless other.is_a?(Vertex)
      raise VertexError.new("Not in the same DAG") if @dag != other.dag
      raise CyclicError.new("Would become cyclic") if other.reachable?(self)

      edge = Edge.new(@dag, other, attrs)
      @edges << edge
      edge
    end

    # Return the proxied key-value hash tree visible from this vertex
    # via its edges and all its ancestors.
    #
    # Calling #to_hash instead will return a regular hash tree, without
    # any special properties, e.g. for serializing as YAML or JSON.

    def to_hash_proxy
      result = @dag.hash_proxy_class.new
      edges.each do |edge|
        result.merge!(edge.to_hash_proxy)
      end
      result.merge!(@attrs)
    end
  end
end
