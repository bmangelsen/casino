require 'rails_helper'

RSpec.describe GameTypeController, type: :controller do
  fixtures :users

  before(:each) do
    @type = GameType.create(name: "Blackjack", active: false)
  end

  it "can be activated" do
    sign_in users(:ben)
    get :activate, params: {id: @type.id}
    expect(response).to redirect_to(admin_view_path)
  end

  it "can be deactivated" do
    sign_in users(:ben)
    get :deactivate, params: {id: @type.id}
    expect(response).to redirect_to(admin_view_path)
  end
end
