# coding: utf-8
require "formup/attr_def"

describe Formup::AttrDef do
  describe "#initailize" do
    context "given not string arguments" do
      before do
        @attr_def = Formup::AttrDef.new(:id, 1)
      end

      describe "#base" do
        it "returns string value" do
          expect(@attr_def.base).to eq "id"
        end
      end

      describe "#attr" do
        it "returns string value" do
          expect(@attr_def.attr).to eq "1"
        end
      end
    end
  end
end
