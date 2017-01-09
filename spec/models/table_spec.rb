require 'rails_helper'

RSpec.describe Table, type: :model do
  fixtures :users

  before(:each) do
    @table = Table.create
    @table.add_dealer
  end

  it "can be found" do
    expect(Table.find_table).to eq(@table)
  end

  it "can add players" do
    user = users(:ben)
    @table.add_player(user)
  end
end
