require 'active_support'
require 'kvdag/error'
require 'kvdag/attrnode'
require 'kvdag/vertex'
require 'kvdag/edge'
require 'kvdag/keypathhash'

class KVDAG
  include Enumerable
  attr_reader :vertices
  attr_reader :hash_proxy_class

  private :initialize
  def initialize(hash_proxy_class = KVDAG::KeyPathHashProxy)
    @vertices = Set.new
    @hash_proxy_class = hash_proxy_class
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
