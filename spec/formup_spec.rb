# coding: utf-8
require "spec_helper"
require "formup"
require "active_model/conversion"
require "active_model/validations"
require "active_model/naming"
require "active_model/translation"

describe Formup do
  context "included" do
    before do
      class TestClass1
        include Formup
      end
      @obj = TestClass1.new
    end

    describe ActiveModel::Conversion do
      it "is included" do
        expect(TestClass1.included_modules.include?(ActiveModel::Conversion)).to eq true
      end
    end

    describe ActiveModel::Validations do
      it "contains ActiveModel::Validations" do
        expect(TestClass1.included_modules.include?(ActiveModel::Validations)).to eq true
      end
    end

    describe ActiveModel::Naming do
      it "is extended" do
        expect((class << TestClass1; self end).included_modules.include?(ActiveModel::Naming)).to eq true
      end
    end

    describe ActiveModel::Translation do
      it "is extended" do
        expect((class << TestClass1; self end).included_modules.include?(ActiveModel::Translation)).to eq true
      end
    end

    describe "#persisted?" do
      it "defined" do
        expect(@obj.respond_to?(:persisted?)).to eq true
      end

      it "returns false" do
        expect(@obj.persisted?).to eq false
      end
    end

    describe ".source" do
      it "difined" do
        expect(TestClass1.respond_to?(:source)).to eq true
      end
    end

    describe ".sources" do
      it "defined" do
        expect { TestClass1.sources }.not_to raise_error
      end

      it "returns empty Hash" do
        expect(TestClass1.sources.length).to eq 0
      end
    end
  end

  context "source method called" do
    before do
      class TestClass2
        include Formup
        source :key1, :attributes => [:attr1, :attr2, :attr3]
        source :key2, :aliases => {:attr1 => :alias1, :attr2 => :alias2}
        source :key3, :attributes => [:attr1, :attr2], :aliases => {:attr3 => :alias3, :attr4 => :alias4}
      end
    end

    before(:each) do
      @obj = TestClass2.new
    end

    describe ".sources" do
      it "has 3 items" do
        expect(TestClass2.sources.length).to eq 3
      end

      it "contains given keys" do
        actual = TestClass2.sources.key?(:key1) && TestClass2.sources.key?(:key2) && TestClass2.sources.key?(:key3)
        expect(actual).to eq true
      end

      it "has values joined key and attributes" do
        expect(TestClass2.sources[:key1][:attr1]).to eq "key1_attr1"
        expect(TestClass2.sources[:key1][:attr2]).to eq "key1_attr2"
        expect(TestClass2.sources[:key1][:attr3]).to eq "key1_attr3"
        expect(TestClass2.sources[:key3][:attr1]).to eq "key3_attr1"
        expect(TestClass2.sources[:key3][:attr2]).to eq "key3_attr2"
      end

      it "has values given by aliases" do
        expect(TestClass2.sources[:key2][:attr1]).to eq "alias1"
        expect(TestClass2.sources[:key2][:attr2]).to eq "alias2"
        expect(TestClass2.sources[:key3][:attr3]).to eq "alias3"
        expect(TestClass2.sources[:key3][:attr4]).to eq "alias4"
      end
    end

    it "define accessor methods by attributes option" do
      expect(@obj.respond_to?(:key1_attr1)).to eq true
      expect(@obj.respond_to?(:key1_attr1=)).to eq true
      expect(@obj.respond_to?(:key1_attr2)).to eq true
      expect(@obj.respond_to?(:key1_attr2=)).to eq true
      expect(@obj.respond_to?(:key1_attr3)).to eq true
      expect(@obj.respond_to?(:key1_attr3=)).to eq true
      expect(@obj.respond_to?(:key3_attr1)).to eq true
      expect(@obj.respond_to?(:key3_attr1=)).to eq true
      expect(@obj.respond_to?(:key3_attr2)).to eq true
      expect(@obj.respond_to?(:key3_attr2=)).to eq true
    end

    it "define accessor methods by aliases option" do
      expect(@obj.respond_to?(:alias1)).to eq true
      expect(@obj.respond_to?(:alias2)).to eq true
      expect(@obj.respond_to?(:alias3)).to eq true
      expect(@obj.respond_to?(:alias4)).to eq true
    end
  end
end
