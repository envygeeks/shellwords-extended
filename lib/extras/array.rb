# Frozen-string-literal: true
# Copyright: 2015-2016 Jordon Bedwell - MIT License
# Encoding: utf-8

module Extras
  module Array
    module ClassMethods
      def allowed
        @allowed ||= begin
          out = {
            :keys => [NilClass, Hash, TrueClass, FalseClass, \
              Regexp, Array, Set, Fixnum, Bignum, Float]
          }
        end
      end
    end

    # allowed_keys - a list of allowed keys that should not be converted.
    # allowed_vals - a list of allowed vals that should not be converted.
    # Stringify an array's keys, skipping anything within the allowed list.
    def stringify(allowed_keys: nil, allowed_vals: nil)
      allowed_keys ||= self.class.allowed[:keys]
      allowed_keys ||= self.class.allowed[:vals]

      map do |v|
        v = v.to_s unless allowed_keys.include?(v.class)
        !v.respond_to?(:stringify) ? v : v.stringify({
          :allowed_keys => allowed_keys,
          :allowed_vals => allowed_vals
        })
      end
    end

    # allowed_keys - a list of allowed keys that should not be converted.
    # allowed_vals - a list of allowed vals that should not be converted.
    # Symbolize an array's keys, skpping anything within the allowed list.
    def symbolize(allowed_keys: nil, allowed_vals: nil)
      allowed_keys ||= self.class.allowed[:keys]
      allowed_vals ||= self.class.allowed[:vals]

      map do |v|
        v = v.to_sym unless !v.respond_to?(:to_sym) || allowed_keys.include?(v.class)
        !v.respond_to?(:symbolize) ? v : v.symbolize({
          :allowed_keys => allowed_keys,
          :allowed_vals => allowed_vals
        })
      end
    end
  end
end

class Array
  prepend Extras::Array
  class << self
    prepend Extras::Array::ClassMethods
  end
end
