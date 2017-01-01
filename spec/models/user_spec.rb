require 'rails_helper'

RSpec.describe User, type: :model do
  include UserHelper
  fixtures :games, :users

  subject(:user) { described_class.new(id: users(:ben).id, email: "useremail@gmail.com") }

  it "has an email address" do
    expect(user.email).to eq("useremail@gmail.com")
  end

  it "can show won games" do
    games(:first).winner = subject.id
    games(:first).save
    expect(won_games_for(subject)).to eq(1)
  end

  it "can be identified" do
    expect(find_users.count).to eq(2)
  end

  it "can be counted" do
    expect(count_users).to eq(2)
  end

  it "can display emails" do
    expect(display_user_emails).to eq(["ben@gmail.com", "tom@gmail.com"])
  end
end
