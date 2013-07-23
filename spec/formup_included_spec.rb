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
      class TestClassForIncluded
        include Formup
      end
      @obj = TestClassForIncluded.new
    end

    describe ActiveModel::Conversion do
      it "is included" do
        expect(TestClassForIncluded.included_modules.include?(ActiveModel::Conversion)).to eq true
      end
    end

    describe ActiveModel::Validations do
      it "contains ActiveModel::Validations" do
        expect(TestClassForIncluded.included_modules.include?(ActiveModel::Validations)).to eq true
      end
    end

    describe ActiveModel::Naming do
      it "is extended" do
        expect((class << TestClassForIncluded; self end).included_modules.include?(ActiveModel::Naming)).to eq true
      end
    end

    describe ActiveModel::Translation do
      it "is extended" do
        expect((class << TestClassForIncluded; self end).included_modules.include?(ActiveModel::Translation)).to eq true
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
        expect(TestClassForIncluded.respond_to?(:source)).to eq true
      end
    end

    describe ".sources" do
      it "defined" do
        expect { TestClassForIncluded.sources }.not_to raise_error
      end

      it "returns empty Hash" do
        expect(TestClassForIncluded.sources.length).to eq 0
      end
    end
  end

end
