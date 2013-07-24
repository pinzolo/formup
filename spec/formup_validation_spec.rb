# coding: utf-8
require "spec_helper"
require "formup"

describe Formup do
  context "included" do
    before do
      class TestClassForValidation
        include Formup

        source :item, :attributes => [:name]
        attr_accessor :price

        validates :item_name, :presence => true
        validates :price, :inclusion => { :in => 0..10000 }
      end
    end

    before(:each) do
      @obj = TestClassForValidation.new(:item_name => "foo")
      @obj.price = 5000
    end

    it "validation of normal attribute is enable" do
      expect(@obj.valid?).to eq true
      @obj.price = -1000
      expect(@obj.valid?).to eq false
    end

    it "validation of attribute that defined by source method is enable" do
      expect(@obj.valid?).to eq true
      @obj.item_name = ""
      expect(@obj.valid?).to eq false
    end
  end
end
