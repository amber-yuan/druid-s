require 'spec_helper'
require 'druid/elements'

describe Druid::Elements::Link do
  describe "when mapping how to find an element" do
    it "should map watir types to same" do
      [:class, :href, :id, :name, :text, :xpath].each do |t|
        identifier = Druid::Elements::Link.identifier_for t => 'value'
        expect(identifier.keys.first).to eql t
      end
    end

    it "should map selenium types to watir" do
      [:link, :link_text].each do |t|
        identifier = Druid::Elements::Link.identifier_for t => 'value'
        expect(identifier.keys.first).to eql :text
      end
    end


  end
end