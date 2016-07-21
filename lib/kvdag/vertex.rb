class KVDAG
  class Vertex
    include AttributeNode
    include Comparable
    attr_reader :dag
    attr_reader :edges

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

    alias children edges

    def parents
      result = Set.new
      dag.vertices.each do |vertex|
        next if vertex.equal?(self)
        vertex.edges.each do |edge|
          result << vertex if edge.to_vertex.equal?(self)
        end
      end
      result
    end

    def reachable?(other)
      other = other.to_vertex unless other.is_a?(Vertex)
      raise VertexError.new("Not in the same DAG") unless @dag.equal?(other.dag)
      
      equal?(other) || @edges.any? {|edge| edge.reachable?(other)}
    end

    def reachable_from?(other)
      other.reachable?(self)
    end

    def decendants
      result = Set.new
      dag.vertices.each {|vertex| result << vertex if reachable?(vertex)}
      result
    end

    def ancestors
      result = Set.new
      dag.vertices.each {|vertex| result << vertex if reachable_from?(vertex)}
      result
    end

    def <=>(other) 
      return -1 if reachable?(other)
      return 1 if reachable_from?(other)
      return 0
    end

    def edge(other, attrs = {})
      other = other.to_vertex unless other.is_a?(Vertex)
      raise VertexError.new("Not in the same DAG") if @dag != other.dag
      raise CyclicError.new("Would become cyclic") if other.reachable?(self)

      edge = Edge.new(@dag, other, attrs)
      @edges << edge
      edge
    end

    def [](attr)
      @attrs[attr] || edges.reduce(nil) do |found, edge|
        found || edge[attr]
      end
    end

    def to_hash
      result = @dag.hash_proxy_class.new
      edges.each do |edge|
        result.merge!(edge.to_hash)
      end
      result.merge!(@attrs).to_hash
    end
  end
end
