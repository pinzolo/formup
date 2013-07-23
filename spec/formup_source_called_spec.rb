# coding: utf-8
require "spec_helper"
require "formup"

describe Formup do
  context "source method called" do
    before do
      class TestClassForSourceCalled
        include Formup
        source :key1, :attributes => [:attr1, :attr2, :attr3]
        source :key2, :aliases => {:attr1 => :alias1, :attr2 => :alias2}, :excludes => :attr1
        source :key3, :attributes => [:attr1, :attr2], :aliases => {:attr3 => :alias3, :attr4 => :alias4}, :excludes => [:attr3, :attr4]
      end
    end

    before(:each) do
      @obj = TestClassForSourceCalled.new
    end

    describe ".sources" do
      it "has 3 items" do
        expect(TestClassForSourceCalled.sources.length).to eq 3
      end

      it "contains given keys" do
        expect(TestClassForSourceCalled.sources.key?(:key1)).to eq true
        expect(TestClassForSourceCalled.sources.key?(:key2)).to eq true
        expect(TestClassForSourceCalled.sources.key?(:key3)).to eq true
      end

      it "has values joined key and attributes" do
        expect(TestClassForSourceCalled.sources[:key1].attribute_defs[:attr1]).to eq "key1_attr1"
        expect(TestClassForSourceCalled.sources[:key1].attribute_defs[:attr2]).to eq "key1_attr2"
        expect(TestClassForSourceCalled.sources[:key1].attribute_defs[:attr3]).to eq "key1_attr3"
        expect(TestClassForSourceCalled.sources[:key3].attribute_defs[:attr1]).to eq "key3_attr1"
        expect(TestClassForSourceCalled.sources[:key3].attribute_defs[:attr2]).to eq "key3_attr2"
      end

      it "has values given by aliases" do
        expect(TestClassForSourceCalled.sources[:key2].attribute_defs[:attr1]).to eq "alias1"
        expect(TestClassForSourceCalled.sources[:key2].attribute_defs[:attr2]).to eq "alias2"
        expect(TestClassForSourceCalled.sources[:key3].attribute_defs[:attr3]).to eq "alias3"
        expect(TestClassForSourceCalled.sources[:key3].attribute_defs[:attr4]).to eq "alias4"
      end

      it "has excludes" do
        expect(TestClassForSourceCalled.sources[:key1].excludes).to eq [:id]
        expect(TestClassForSourceCalled.sources[:key2].excludes).to eq [:attr1]
        expect(TestClassForSourceCalled.sources[:key3].excludes).to eq [:attr3, :attr4]
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
