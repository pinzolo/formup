# coding: utf-8
require "spec_helper"
require "formup/source"
require "active_support/hash_with_indifferent_access"

describe Formup::Source do
  describe "#initialize" do
    context "without attribute_defs" do
      before do
        @src = Formup::Source.new(:user)
      end

      describe "#attribute_defs" do
        it "returns empty Hash" do
          expect(@src.attribute_defs).not_to be_nil
        end
      end
    end

    context "with string key" do
      before do
        @src = Formup::Source.new("user")
      end

      describe "#key" do
        it "returns string keye" do
          expect(@src.key).to eq "user"
        end
      end
    end

    context "with symbol key" do
      before do
        @src = Formup::Source.new(:user)
      end

      describe "#key" do
        it "returns string keye" do
          expect(@src.key).to eq "user"
        end
      end
    end

    context "with nil as key" do
      it "raise error" do
        expect { Formup::Source.new(nil) }.to raise_error
      end
    end

    context "with attribute_defs" do
      before do
        @src = Formup::Source.new(:user, {:name => :nickname, :email => :user_email})
      end

      describe "#attribute_defs" do
        it "returns HashWithIndifferentAccess" do
          expect(@src.attribute_defs).to be_a_instance_of(ActiveSupport::HashWithIndifferentAccess)
        end

        it "has name key" do
          expect(@src.attribute_defs.key?(:name)).to be_true
        end

        it "has email key" do
          expect(@src.attribute_defs.key?(:email)).to be_true
        end

        it "can access string key" do
          expect(@src.attribute_defs.key?("name")).to be_true
        end

        it "has name value same with given hash" do
          expect(@src.attribute_defs["name"]).to eq :nickname
        end

        it "has email value same with given hash" do
          expect(@src.attribute_defs["email"]).to eq :user_email
        end
      end
    end
  end
end
