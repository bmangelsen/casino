require 'rails_helper'

RSpec.describe GameType, type: :model do
  subject(:game_type) { described_class.new(name: "Blackjack", active: false) }
  it "can be activated" do
    subject.activate
    expect(subject.active).to eq(true)
  end

  it "can be deactivated" do
    subject.activate
    subject.deactivate
    expect(subject.active).to eq(false)
  end
end
