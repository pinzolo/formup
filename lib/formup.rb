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
  def initialize(params = {})
    return unless params

    parameters = params.dup.with_indifferent_access
    self.class.sources.each do |_, src|
      src.attribute_defs.each do |_, attr|
        __send__(attr.to_s + "=", parameters[attr]) if parameters.key?(attr)
      end
    end
  end

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

  def load(params = {})
    params.each do |k, v|
      if self.class.sources.key?(k)
        source = self.class.sources[k]
        source.attribute_defs.each do |base, attr|
          value = extract_value(v, base)
          __send__(attr.to_s + "=", value) if value
        end
      end
    end
  end

  private
  def extract_value(obj, attr)
    if obj.respond_to?(attr)
      obj.__send__(attr)
    elsif obj.respond_to?(:[])
      obj[attr.to_s] || obj[attr.to_sym]
    else
      nil
    end
  end
  # }}}
end
