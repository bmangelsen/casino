require 'rails_helper'

RSpec.feature "View root" do
  fixtures :users, :game_types
  it "visits the root" do
    login_as(users(:ben))
    visit '/'
    expect(page).to have_content "Check out the game rules or hop onto a table:"
  end
end
