# coding: utf-8
require "formup/version"
require "formup/source"
require "active_support/concern"
require "active_model/conversion"
require "active_model/validations"
require "active_model/naming"
require "active_model/translation"

module Formup
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Conversion
    include ActiveModel::Validations
    extend ActiveModel::Naming
    extend ActiveModel::Translation
  end

  # Class methods {{{
  module ClassMethods
    def sources
      initialize_sources
      @sources.dup
    end

    def source(key, options={})
      initialize_sources
      attribute_defs = create_attribute_defs(key, options[:attributes], options[:aliases])
      @sources[key] = Formup::Source.new(key, attribute_defs, options[:excludes])
      deploy_attributes(attribute_defs)
    end

    private
    def create_attribute_defs(key, attributes, aliases)
      attribute_defs = {}.with_indifferent_access

      if attributes
        attributes.each do |attr|
          attribute_defs[attr.to_s] = "#{key}_#{attr}"
        end
      end
      if aliases
        aliases.each do |k, v|
          attribute_defs[k.to_s] = v.to_s
        end
      end
      attribute_defs
    end

    def deploy_attributes(defs)
      defs.values.each do |attr|
        attr_accessor attr
      end
    end

    def initialize_sources
      @sources ||= {}.with_indifferent_access
    end
  end
  # }}}

  # Instance methods {{{
  def persisted?
    false
  end

  def params_for(key, full = false)
    parameters = {}.with_indifferent_access
    return parameters unless self.class.sources.key?(key)

    source = self.class.sources[key]
    source.attribute_defs.inject(parameters) do |result, (key, value)|
      result[key] = __send__(value) if full || source.excludes.all? { |attr| attr.to_sym != key.to_sym }
      result
    end
  end
  # }}}
end
