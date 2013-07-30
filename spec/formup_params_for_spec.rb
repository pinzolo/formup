# coding: utf-8
require "spec_helper"
require "formup"

describe Formup do
  before do
    class TestClassForParamsFor1
      include Formup
      source :key1, :attributes => [:id, :name, :value]
      source :key2, :attributes => [:email], :aliases => { :id => :key, :name => :label }
    end
  end

  before(:each) do
    @obj = TestClassForParamsFor1.new do
      key1_id = 1
      key1_name = "foo"
      key1_value = "bar"
      key = 2
      label = "baz"
      key2_email = "hoge@example.com"
    end
  end

  describe "#params_for(key)" do
    it "returns hash that doesn't have id key(declared by attributes)" do
      params = @obj.params_for(:key1)
      expect(params.length).to eq 2
      expect(params.key?(:id)).to eq false
      expect(params.key?(:name)).to eq true
      expect(params.key?(:value)).to eq true
    end

    it "returns hash that doesn't have id key(declared by aliases)" do
      params = @obj.params_for(:key2)
      expect(params.length).to eq 2
      expect(params.key?(:id)).to eq false
      expect(params.key?(:name)).to eq true
      expect(params.key?(:email)).to eq true
    end
  end

  describe "#params_for(key, symbol)" do
    it "returns hash that doesn't have name key(declared by attributes)" do
      params = @obj.params_for(:key1, :name)
      expect(params.length).to eq 2
      expect(params.key?(:id)).to eq true
      expect(params.key?(:name)).to eq false
      expect(params.key?(:value)).to eq true
    end

    it "returns hash that doesn't have name key(declared by aliases)" do
      params = @obj.params_for(:key2, :name)
      expect(params.length).to eq 2
      expect(params.key?(:id)).to eq true
      expect(params.key?(:name)).to eq false
      expect(params.key?(:email)).to eq true
    end
  end

  describe "#params_for(key, string)" do
    it "returns hash that doesn't have name key(declared by attributes)" do
      params = @obj.params_for(:key1, "name")
      expect(params.length).to eq 2
      expect(params.key?(:id)).to eq true
      expect(params.key?(:name)).to eq false
      expect(params.key?(:value)).to eq true
    end

    it "returns hash that doesn't have name key(declared by aliases)" do
      params = @obj.params_for(:key2, "name")
      expect(params.length).to eq 2
      expect(params.key?(:id)).to eq true
      expect(params.key?(:name)).to eq false
      expect(params.key?(:email)).to eq true
    end
  end

  describe "#params_for(key, array)" do
    it "returns hash that doesn't have id and name keys(declared by attributes)" do
      params = @obj.params_for(:key1, :id, :name)
      expect(params.length).to eq 1
      expect(params.key?(:id)).to eq false
      expect(params.key?(:name)).to eq false
      expect(params.key?(:value)).to eq true
    end

    it "returns hash that doesn't have id and name keys(declared by aliases)" do
      params = @obj.params_for(:key2, "id", "name")
      expect(params.length).to eq 1
      expect(params.key?(:id)).to eq false
      expect(params.key?(:name)).to eq false
      expect(params.key?(:email)).to eq true
    end
  end

  describe "#params_for(key, false)" do
    it "returns hash that has all keys(declared by attributes)" do
      params = @obj.params_for(:key1, false)
      expect(params.length).to eq 3
      expect(params.key?(:id)).to eq true
      expect(params.key?(:name)).to eq true
      expect(params.key?(:value)).to eq true
    end

    it "returns hash that has all keys(declared by aliases)" do
      params = @obj.params_for(:key2, false)
      expect(params.length).to eq 3
      expect(params.key?(:id)).to eq true
      expect(params.key?(:name)).to eq true
      expect(params.key?(:email)).to eq true
    end
  end
end
