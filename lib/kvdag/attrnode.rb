class KVDAG

  # Mixin with common methods for managing the +attrs+ of
  # vertices and edges in a KVDAG.

  module AttributeNode
    attr_reader :attrs

    # Returns the value for an +attr+. If the +attr+ can't be found,
    # it will raise a KeyError exception.
    #
    # +options+:
    # [+shallow+] If true, lookup is limited to attrs defined in
    #             this attrnode. The default is lookup in the tree
    #             returned by +to_hash_proxy+.

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
    # [+shallow+] If true, lookup is limited to attrs defined in
    #             this attrnode. The default is lookup in the tree
    #             returned by +to_hash_proxy+.

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

    # :call-seq:
    #   match?()                           -> true
    #   match?(method: match, ...)         -> true or false
    #   match?(one?:{ matches }, ...)      -> true or false
    #   match?(any?:{ matches }, ...)      -> true or false
    #   match?(all?:{ matches }, ...)      -> true of false
    #   match?(none?:{ matches }, ...)     -> true or false
    #
    # Checks if the key-value view visible from a node matches all of
    # set of filters. An empty filter set is considered a match.
    #
    # Any +method+ given will be matched against its result:
    #   match === self.send(method)
    #
    # +matches+ should be a hash with 'key.path' strings at keys,
    # and +match+ values to check for equality:
    #   match === self[key]
    #
    # Examples:
    #
    #   node.match?(class:KVDAG::Vertex)
    #   node.match?(none?:{'key' => Integer})
    #   node.match?(all?:{'key' => /this|that/})
    #   node.match?(any?:{'key1' => 'this', 'key2' => 'that'})
    #   node.match?(one?:{'key1' => 'this', 'key2' => 'that'})

    def match?(filter={})
      valid_enumerators = [:none?, :one?, :any?, :all?]

      filter.all? do |item|
        method, match = item
        if valid_enumerators.include?(method)
          match.send(method) do |item|
            value === self[key]
          end
        else
          match === self.send(method)
        end
      end
    end
  end
end
