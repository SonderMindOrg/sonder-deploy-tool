require "spec_helper"

RSpec.describe Sonder::Deploy::Tool do
  it "has a version number" do
    expect(Sonder::Deploy::Tool::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
