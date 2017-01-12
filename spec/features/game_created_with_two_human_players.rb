# require 'rails_helper'
#
# RSpec.feature "Second player joins table" do
#   fixtures :users, :game_types
#   it "creates a second human player on a table" do
#     in_browser(:one) do
#       login_as(users(:ben))
#       visit '/'
#       click_link 'Join a table!'
#     end
#
#     expect(Game.last.players.count).to eq(2)
#
#     in_browser(:two) do
#       login_as(users(:tom))
#       visit '/'
#       click_link 'Join a table!'
#     end
#
#     in_browser(:one) do
#       click_link "Stand"
#       binding.pry
#       click_link "New Game!"
#     end
#
#     expect(Game.last.players.count).to eq(3)
#   end
# end
