# coding: utf-8
require "active_support/core_ext/hash/indifferent_access"

module Formup
  class Source

    attr_accessor :key, :attribute_defs
    def initialize(key, attribute_defs = {})
      raise "Formup::Source require key param." if key.nil?

      @key = key.to_s
      @attribute_defs = attribute_defs.with_indifferent_access
    end
  end
end
