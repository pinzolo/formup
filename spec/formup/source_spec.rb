# coding: utf-8
require "spec_helper"
require "formup/source"
require "active_support/hash_with_indifferent_access"

describe Formup::Source do
  describe "#initialize" do
    context "with key only" do
      before do
        @src = Formup::Source.new(:user)
      end

      describe "#attribute_defs" do
        it "returns empty Hash" do
          expect(@src.attribute_defs).not_to be_nil
        end
      end

      describe "#excludes" do
        it "returns Array" do
          expect(@src.excludes).to be_a_instance_of(Array)
        end

        it "has 1 item" do
          expect(@src.excludes.length).to eq 1
        end

        it "item is :id" do
          expect(@src.excludes.first).to eq :id
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

    context "with symbol excludes" do
      before do
        @src = Formup::Source.new(:user, {:name => :nickname, :email => :user_email}, :email)
      end

      describe "#excludes" do
        it "returns Array" do
          expect(@src.excludes).to be_a_instance_of(Array)
        end

        it "contains :email" do
          expect(@src.excludes.include?(:email)).to eq true
        end
      end
    end

    context "with array exceludes" do
      before do
        @src = Formup::Source.new(:user, {:name => :nickname, :email => :user_email}, [:name, :email])
      end

      describe "#excludes" do
        it "returns Array" do
          expect(@src.excludes).to be_a_instance_of(Array)
        end

        it "contains :name" do
          expect(@src.excludes.include?(:name)).to eq true
        end

        it "contains :email" do
          expect(@src.excludes.include?(:email)).to eq true
        end
      end
    end
  end
end
