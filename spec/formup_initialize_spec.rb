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
      end

      class DataModel
        attr_accessor :id, :name, :email
      end
    end

    context "with hash" do
      before do
        @obj = TestClassForInitialize.new(:key1 => { :id => 1, :name => "foo", :value => true})
      end

      it "values assigned" do
        expect(@obj.key1_id).to eq 1
        expect(@obj.key1_name).to eq "foo"
        expect(@obj.key1_value).to eq true
      end

      it "other values not assined" do
        expect(@obj.key).to be_nil
        expect(@obj.label).to be_nil
        expect(@obj.key2_email).to be_nil
      end
    end

    context "with data model" do
      before do
        data = DataModel.new
        data.id = 2
        data.name = "bar"
        data.email = "test@example.com"
        @obj = TestClassForInitialize.new(:key2 => data)
      end

      it "values assigned" do
        expect(@obj.key).to eq 2
        expect(@obj.label).to eq "bar"
        expect(@obj.key2_email).to eq "test@example.com"
      end

      it "other values not assined" do
        expect(@obj.key1_id).to be_nil
        expect(@obj.key1_name).to be_nil
        expect(@obj.key1_value).to be_nil
      end
    end

    context "with hash and data model" do
      before do
        data = DataModel.new
        data.id = 2
        data.name = "bar"
        data.email = "test@example.com"
        @obj = TestClassForInitialize.new(:key1 => { :id => 1, :name => "foo", :value => true}, :key2 => data)
      end

      it "values assigned" do
        expect(@obj.key1_id).to eq 1
        expect(@obj.key1_name).to eq "foo"
        expect(@obj.key1_value).to eq true
        expect(@obj.key).to eq 2
        expect(@obj.label).to eq "bar"
        expect(@obj.key2_email).to eq "test@example.com"
      end
    end
  end
end
