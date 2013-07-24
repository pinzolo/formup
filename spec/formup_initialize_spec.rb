# coding: utf-8
require "spec_helper"
require "formup"

describe Formup do
  describe "#initialize" do
    before do
      class TestClassForInitialize
        include Formup
        source :key1, :attributes => [:id, :name, :value]
        source :key2, :attributes => [:email], :aliases => { :id => :key, :name => :label }

        attr_accessor :extra_params_handled

        def handle_extra_params(params)
          @extra_params_handled = true
        end
      end
      @obj = TestClassForInitialize.new({:key1_id => 1, :key1_name => "foo", :key1_value => true,
                                         :key => 2, :label => "bar", :key2_email => "test@example.com", :extra => "baz"})
    end

    it "values assigned" do
      expect(@obj.key1_id).to eq 1
      expect(@obj.key1_name).to eq "foo"
      expect(@obj.key1_value).to eq true
      expect(@obj.key).to eq 2
      expect(@obj.label).to eq "bar"
      expect(@obj.key2_email).to eq "test@example.com"
    end

    it "handle_extra_params called" do
      expect(@obj.extra_params_handled).to eq true
    end
  end
end
