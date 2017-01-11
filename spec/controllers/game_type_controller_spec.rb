require 'rails_helper'

RSpec.describe GameTypeController, type: :controller do
  fixtures :users

  before(:each) do
    @type = GameType.create(name: "Blackjack", active: false)
  end

  it "can be activated" do
    sign_in users(:ben)
    get :activate, params: {id: @type.id}
    @type.reload
    expect(@type.active).to eq(true)
  end

  it "can be deactivated" do
    sign_in users(:ben)
    get :activate, params: {id: @type.id}
    get :deactivate, params: {id: @type.id}
    @type.reload
    expect(@type.active).to eq(false)
  end
end
