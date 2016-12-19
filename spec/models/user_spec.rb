require 'rails_helper'

RSpec.describe User, type: :model do

  subject(:user) { described_class.new(email: "useremail@gmail.com") }

  it "has an email address" do
    expect(user.email).to eq("useremail@gmail.com")
  end
end
