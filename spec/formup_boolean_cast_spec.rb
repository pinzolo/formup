# coding: utf-8
require "spec_helper"
require "formup"

describe Formup do
  describe "boolean cast method" do
    before do
      class TestClassForBooleanCastMethod
        include Formup
        source :key, :attributes => [:value]
      end
    end

    before(:each) do
      @model = TestClassForBooleanCastMethod.new
    end

    context "when true assigned" do
      before do
        @model.key_value = true
      end
      it "returns true" do
        expect(@model.key_value?).to eq true
      end
    end

    context "when 1 assigned" do
      before do
        @model.key_value = 1
      end
      it "returns true" do
        expect(@model.key_value?).to eq true
      end
    end

    context "when '1' assigned" do
      before do
        @model.key_value = '1'
      end
      it "returns true" do
        expect(@model.key_value?).to eq true
      end
    end

    context "when 't' assigned" do
      before do
        @model.key_value = 't'
      end
      it "returns true" do
        expect(@model.key_value?).to eq true
      end
    end

    context "when 'true' assigned" do
      before do
        @model.key_value = 'true'
      end
      it "returns true" do
        expect(@model.key_value?).to eq true
      end
    end

    context "when false assigned" do
      before do
        @model.key_value = false
      end
      it "returns false" do
        expect(@model.key_value?).to eq false
      end
    end

    context "when 0 assigned" do
      before do
        @model.key_value = 0
      end
      it "returns false" do
        expect(@model.key_value?).to eq false
      end
    end

    context "when '0' assigned" do
      before do
        @model.key_value = '0'
      end
      it "returns false" do
        expect(@model.key_value?).to eq false
      end
    end

    context "when 'f' assigned" do
      before do
        @model.key_value = 'f'
      end
      it "returns false" do
        expect(@model.key_value?).to eq false
      end
    end

    context "when 'false' assigned" do
      before do
        @model.key_value = 'false'
      end
      it "returns false" do
        expect(@model.key_value?).to eq false
      end
    end

    context "when other Number assigned" do
      before do
        @model.key_value = 10
      end
      it "returns false" do
        expect(@model.key_value?).to eq false
      end
    end

    context "when other String assigned" do
      before do
        @model.key_value = 'test'
      end
      it "returns false" do
        expect(@model.key_value?).to eq false
      end
    end

    context "when other Object assigned" do
      before do
        @model.key_value = :test
      end
      it "returns false" do
        expect(@model.key_value?).to eq false
      end
    end

    context "when nil" do
      before do
        @model.key_value = nil
      end
      it "returns false" do
        expect(@model.key_value?).to eq false
      end
    end
  end
end
