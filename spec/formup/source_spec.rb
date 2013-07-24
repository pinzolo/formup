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
        it "returns Array" do
          expect(@src.attribute_defs).to be_a_instance_of(Array)
        end

        it "returns Formup::AttrDef array" do
          expect(@src.attribute_defs.all? { |attr_def| attr_def.is_a?(Formup::AttrDef) }).to eq true
        end
      end

      describe "#base?" do
        it "has name as base" do
          expect(@src.base?("name")).to eq true
        end

        it "has email as base" do
          expect(@src.base?("email")).to eq true
        end

        it "can accept symbol argument" do
          expect(@src.base?(:name)).to eq true
        end
      end

      describe "#base" do
        context "argument is nickname" do
          it "returns name" do
            expect(@src.base("nickname")).to eq "name"
          end
        end

        context "argument is user_email" do
          it "returns email" do
            expect(@src.base("user_email")).to eq "email"
          end
        end

        context "argument is user_age" do
          it "returns nil" do
            expect(@src.base("user_age")).to be_nil
          end
        end

        context "argument is a symbol" do
          it "returns same value when string argument" do
            expect(@src.base(:user_email)).to eq "email"
          end
        end
      end

      describe "#attr?" do
        it "has nickname as attr" do
          expect(@src.attr?("nickname")).to eq true
        end

        it "has user_email as attr" do
          expect(@src.attr?("user_email")).to eq true
        end

        it "can accept symbol argument" do
          expect(@src.attr?(:nickname)).to eq true
        end
      end

      describe "#attr" do
        context "argument is name" do
          it "returns nickname" do
            expect(@src.attr("name")).to eq "nickname"
          end
        end

        context "argument is email" do
          it "returns user_email" do
            expect(@src.attr("email")).to eq "user_email"
          end
        end

        context "arument is age" do
          it "returns nil" do
            expect(@src.attr("age")).to be_nil
          end
        end

        context "argument is a symbol" do
          it "returns same value when string argument" do
            expect(@src.attr(:name)).to eq "nickname"
          end
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
