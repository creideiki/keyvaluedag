require 'delegate'
require 'active_support/core_ext/hash'

class KVDAG
  class KeyPathHashProxy < DelegateClass(Hash)
    class KeyPath < Array
      private :initialize
      def initialize(keypath)
        keypath = keypath.split(".") if keypath.is_a?(String)
        super
      end
    end

    private :initialize
    def initialize(hash = {})
      raise TypeError.new("Must be initialized with a `hash`") unless hash.is_a?(Hash)
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

    def [](keypath)
      *keypath, key = KeyPath.new(keypath)
      hash = @hash

      keypath.each {|key| hash = hash[key]}
      hash[key]
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
  end
end
