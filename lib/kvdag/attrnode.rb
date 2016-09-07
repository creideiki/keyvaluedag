class KVDAG

  # Mixin with common methods for managing the +attrs+ of
  # vertices and edges in a KVDAG.

  module AttributeNode
    attr_reader :attrs

    # Returns the value for an +attr+. If the +attr+ can't be found,
    # it will raise a KeyError exception.
    #
    # +options+:
    #   shallow: If true, lookup is limited to attrs defined in
    #            this attrnode. The default is lookup in the tree
    #            returned by +to_hash_proxy+.

    def fetch(attr, options = {})
      case
      when (options[:shallow])
        @attrs.fetch(attr)
      when self.respond_to?(:to_hash_proxy)
        to_hash_proxy.fetch(attr)
      else
        to_hash.fetch(attr)
      end
    end

    # Return the value for an +attr+, or +nil+ if the +attr+ can't be found.
    #
    # +options+:
    #   shallow: If true, lookup is limited to attrs defined in
    #            this attrnode. The default is lookup in the tree
    #            returned by +to_hash_proxy+.

    def [](attr, options = {})
      fetch(attr, options)
    rescue
      nil
    end

    # Set the +value+ for an +attr+ in this attrnode.

    def []=(attr, value)
      @attrs[attr] = value
    end

    def to_hash
      if self.respond_to?(:to_hash_proxy) then
        to_hash_proxy.to_hash
      else
        @attrs
      end
    end

    def merge!(other)
      @attrs.merge!(other.to_hash)
      self
    end

    # Filter the key-value view of a vertex by a list of key prefixes,
    # and return a hash_proxy containing only those trees.
    #
    # :call-seq:
    #   filter("key.path1", ..., "key.pathN") -> hash_proxy

    def filter(*keys)
      if self.respond_to?(:to_hash_proxy) then
        to_hash_proxy.filter(*keys)
      else
        raise NotImplementedError.new("not implemented for plain hash")
      end
    end
  end
end
