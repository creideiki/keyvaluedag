require 'delegate'
require 'active_support/core_ext/hash'

class KVDAG
  class KeyPathHashProxy < DelegateClass(Hash)
    class KeyPath < Array
      private :initialize
      def initialize(keypath)
        keypath = keypath.split('.') if keypath.is_a?(String)
        super
      end
    end

    private :initialize
    def initialize(hash = {})
      raise TypeError.new('Must be initialized with a `hash`') unless hash.is_a?(Hash)
      @hash = hash.deep_stringify_keys
      super(@hash)
    end

    def merge(other, &block)
      self.class.new(@hash.deep_merge(other.deep_stringify_keys, &block))
    end

    def merge!(other, &block)
      @hash.deep_merge!(other.deep_stringify_keys, &block)
      self
    end

    # :call-seq:
    #   fetch("key.path")      -> value or KeyError
    #   fetch(["key", "path"]) -> value or KeyError
    #
    # Return the value at a specified keypath. If the keypath
    # does not specify a terminal value, return the remaining
    # subtree instead.
    #
    # Raises a KeyError exception if the keypath is not found.

    def fetch(keypath)
      *keysubpath, key = KeyPath.new(keypath)
      hash = @hash

      keysubpath.each { |key| hash = hash.fetch(key) }
      hash.fetch(key)
    rescue KeyError
      raise KeyError.new("keypath not found: #{keypath.inspect}")
    end

    # :call-seq:
    #   []("key.path")      -> value or nil
    #   [](["key", "path"]) -> value or nil
    #
    # Return the value at a specified keypath. If the keypath
    # does not specify a terminal value, return the remaining
    # subtree instead.
    #
    # Returns nil if the keypath is not found.

    def [](keypath)
      fetch(keypath)
    rescue
      nil
    end

    def []=(keypath, value)
      *keypath, key = KeyPath.new(keypath)

      if keypath.empty? then
        hash = @hash
      else
        if not hash = self[keypath] then
          self[keypath] = hash = Hash.new
        end
      end

      hash[key] = value
    end

    # :call-seq:
    #   filter("key.path1", ..., "key.pathN") -> KeyPathHashProxy
    #
    # Filter a keypathhash tree by a list of keypath prefixes, and
    # return a new keypathhash containing only those trees.
    #
    # Raises a KeyError exception if any of the specified keypaths
    # cannot be found.

    def filter(*keypaths)
      result = self.class.new
      keypaths.each do |keypath|
        result[keypath] = self.fetch(keypath)
      end
      result
    end
  end
end
