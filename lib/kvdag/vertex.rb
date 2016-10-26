class KVDAG

  # A vertex in a KVDAG

  class Vertex
    include AttributeNode
    include Comparable
    attr_reader :dag
    attr_reader :edges
    attr_reader :reverse_edges

    # Create a new vertex in a KVDAG, optionally loaded
    # with key-values.
    #
    # N.B: KVDAG::Vertex.new should never be called directly,
    # always use KVDAG#vertex to create vertices.

    private :initialize
    def initialize(dag, attrs = {})
      @edges = Set.new
      @reverse_edges = Set.new
      @dag = dag
      @attrs = dag.hash_proxy_class.new(attrs)

      @dag.vertices << self
    end

    def inspect
      "#<%s @attr=%s @edges=%s>" % [self.class, @attrs.to_hash, @edges.to_a]
    end

    alias to_s inspect

    # :call-seq:
    #   vtx.parents                 -> all parents
    #   vtx.parents(filter)         -> parents matching +filter+
    #   vtx.parents {|cld| ... }    -> call block with each parent
    #
    # Returns the set of all direct parents, possibly filtered by #match?
    # expressions. If a block is given, call it with each parent.

    def parents(filter={}, &block)
      result = Set.new(edges.map {|edge|
                         edge.to_vertex
                       }.select {|parent|
                         parent.match?(filter)
                       })

      if block_given?
        result.each(&block)
      else
        result
      end
    end

    # :call-seq:
    #   vtx.children                 -> all children
    #   vtx.children(filter)         -> children matching +filter+
    #   vtx.children {|cld| ... }    -> call block with each child
    #
    # Returns the set of all direct children, possibly filtered by #match?
    # expressions. If a block is given, call it with each child.

    def children(filter={}, &block)
      result = Set.new(reverse_edges.map {|edge|
                         edge.to_vertex
                       }.select {|child|
                         child.match?(filter)
                       })

      if block_given?
        result.each(&block)
      else
        result
      end
    end

    # Is +other+ vertex reachable via any of my #edges?
    #
    # A KVDAG::VertexError is raised if vertices belong
    # to different KVDAG.

    def reachable?(other)
      raise VertexError.new("Not in the same DAG") unless @dag.equal?(other.dag)

      equal?(other) || parents.any? {|parent| parent.reachable?(other)}
    end

    # Am I reachable from +other+ via any of its #edges?
    #
    # A KVDAG::VertexError is raised if vertices belong
    # to different KVDAG.

    def reachable_from?(other)
      other.reachable?(self)
    end

    # Return the set of this object and all its parents, and their
    # parents, recursively
    #
    # This is the same as all #reachable? vertices.


    def ancestors
      result = Set.new([self])
      parents.each {|p| result += p.ancestors }
      result
    end

    # Return the set of this object and all its children, and their
    # children, recursively
    #
    # This is the same as all #reachable_from? vertices.

    def descendants
      result = Set.new([self])
      children.each {|c| result += c.descendants }
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
      reverse_edge = Edge.new(@dag, self, {})
      other.add_reverse_edge(reverse_edge)
      edge
    end

    # Create a reverse edge back to the +other+ vertex, which has a
    # real edge to this vertex.
    #
    # Reverse edges have no attributes and do not participate in graph
    # operations, other than as a speed-up for finding incoming edges.
    #
    # Do not call this except from #edge, which performs all required
    # sanity checks.

    def add_reverse_edge(other)
      @reverse_edges << other
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
