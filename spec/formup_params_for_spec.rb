# coding: utf-8
require "spec_helper"
require "formup"

describe Formup do
  context "default exclude attributes" do
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
      it "returned hash does'nt contain id key(declared by attributes)" do
        params = @obj.params_for(:key1)
        expect(params.length).to eq 2
        expect(params.key?(:id)).to eq false
        expect(params.key?(:name)).to eq true
        expect(params.key?(:value)).to eq true
      end

      it "returned hash does'nt contain id key(declared by aliases)" do
        params = @obj.params_for(:key2)
        expect(params.length).to eq 2
        expect(params.key?(:id)).to eq false
        expect(params.key?(:name)).to eq true
        expect(params.key?(:email)).to eq true
      end
    end

    describe "#params_for(key, false)" do
      it "returned hash does'nt contain id key(declared by attributes)" do
        params = @obj.params_for(:key1, false)
        expect(params.length).to eq 2
        expect(params.key?(:id)).to eq false
        expect(params.key?(:name)).to eq true
        expect(params.key?(:value)).to eq true
      end

      it "returned hash does'nt contain id key(declared by aliases)" do
        params = @obj.params_for(:key2, false)
        expect(params.length).to eq 2
        expect(params.key?(:id)).to eq false
        expect(params.key?(:name)).to eq true
        expect(params.key?(:email)).to eq true
      end
    end

    describe "params_for(key, true)" do
      it "returned hash contains id key(declared by attributes)" do
        params = @obj.params_for(:key1, true)
        expect(params.length).to eq 3
        expect(params.key?(:id)).to eq true
        expect(params.key?(:name)).to eq true
        expect(params.key?(:value)).to eq true
      end

      it "returned hash contains id key(declared by aliases)" do
        params = @obj.params_for(:key2, true)
        expect(params.length).to eq 3
        expect(params.key?(:id)).to eq true
        expect(params.key?(:name)).to eq true
        expect(params.key?(:email)).to eq true
      end
    end
  end

  context "original exclude attributes" do
    before do
      class TestClassForParamsFor2
        include Formup
        exclude_attributes :name
        source :key1, :attributes => [:id, :name, :value]
        source :key2, :attributes => [:email], :aliases => { :id => :key, :name => :label }
      end
    end

    before(:each) do
      @obj = TestClassForParamsFor2.new do
        key1_id = 1
        key1_name = "foo"
        key1_value = "bar"
        key = 2
        label = "baz"
        key2_email = "hoge@example.com"
      end
    end

    describe "#params_for(key)" do
      it "returned hash does'nt contain name key(declared by attributes)" do
        params = @obj.params_for(:key1)
        expect(params.length).to eq 2
        expect(params.key?(:id)).to eq true
        expect(params.key?(:name)).to eq false
        expect(params.key?(:value)).to eq true
      end

      it "returned hash does'nt contain id key(declared by aliases)" do
        params = @obj.params_for(:key2)
        expect(params.length).to eq 2
        expect(params.key?(:id)).to eq true
        expect(params.key?(:name)).to eq false
        expect(params.key?(:email)).to eq true
      end
    end

    describe "#params_for(key, false)" do
      it "returned hash does'nt contain name key(declared by attributes)" do
        params = @obj.params_for(:key1, false)
        expect(params.length).to eq 2
        expect(params.key?(:id)).to eq true
        expect(params.key?(:name)).to eq false
        expect(params.key?(:value)).to eq true
      end

      it "returned hash does'nt contain id key(declared by aliases)" do
        params = @obj.params_for(:key2, false)
        expect(params.length).to eq 2
        expect(params.key?(:id)).to eq true
        expect(params.key?(:name)).to eq false
        expect(params.key?(:email)).to eq true
      end
    end

    describe "params_for(key, true)" do
      it "returned hash contains name key(declared by attributes)" do
        params = @obj.params_for(:key1, true)
        expect(params.length).to eq 3
        expect(params.key?(:id)).to eq true
        expect(params.key?(:name)).to eq true
        expect(params.key?(:value)).to eq true
      end

      it "returned hash contains id key(declared by aliases)" do
        params = @obj.params_for(:key2, true)
        expect(params.length).to eq 3
        expect(params.key?(:id)).to eq true
        expect(params.key?(:name)).to eq true
        expect(params.key?(:email)).to eq true
      end
    end
  end
end
