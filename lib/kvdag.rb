require 'active_support'
require 'kvdag/error'
require 'kvdag/attrnode'
require 'kvdag/vertex'
require 'kvdag/edge'

class KVDAG
  include Enumerable
  attr_reader :vertices

  private :initialize
  def initialize
    @vertices = Set.new
  end

  def inspect
    "#<%s:%x(%d vertices, %d edges)>" % [self.class, self.object_id,
                                         vertices.length, edges.length]
  end
  
  def vertex(attrs = {})
    KVDAG::Vertex.new(self, attrs)
  end

  def edges
    @vertices.reduce(Set.new) {|edges,vertex| edges + vertex.edges}
  end

  def each(&block)
    @vertices.each(&block)
  end
end
