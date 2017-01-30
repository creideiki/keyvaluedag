require 'active_support'
require 'kvdag/version'
require 'kvdag/error'
require 'kvdag/attrnode'
require 'kvdag/vertex'
require 'kvdag/edge'
require 'kvdag/keypathhash'

# Directed Acyclic Graph for multiple inheritance key-value lookup

class KVDAG
  include Enumerable

  attr_reader :hash_proxy_class

  # Create a new KVDAG, optionally using a specialized
  # hash class for storing key-values. The default is to use
  # a dot-separated keypath proxy for storing key-values like
  #
  #     hsh["a.b.c"] = value
  #
  # in a tree of hashes
  #
  #     {"a" => {"b" => {"c" => value}}}
  #
  # The default hash proxy will also stringify all keys, and
  # makes all merge operations deep merges.

  private :initialize
  def initialize(hash_proxy_class = KVDAG::KeyPathHashProxy)
    @vertices = Set.new
    @hash_proxy_class = hash_proxy_class
  end

  def inspect
    '#<%s:%x(%d vertices, %d edges)>' % [self.class, self.object_id,
                                         vertices.length, edges.length]
  end

  # Create a new vertex in this DAG, optionally loaded with
  # key-values.

  def vertex(attrs = {})
    KVDAG::Vertex.new(self, attrs)
  end

  # Return the set of all vertices, possibly filtered by
  # Vertex#match? expressions.

  def vertices(filter = {})
    return @vertices if filter.empty?

    Set.new(@vertices.select{|vertex| vertex.match?(filter) })
  end

  # Return the set of all edges

  def edges
    @vertices.reduce(Set.new) {|edges, vertex| edges + vertex.edges}
  end

  # Enumerate all vertices in the DAG, possibly filtered
  # by Vertex#match? expressions.

  def each(filter = {}, &block)
    vertices(filter).each(&block)
  end
end
