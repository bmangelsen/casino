require 'rails_helper'

RSpec.describe User, type: :model do
  fixtures :games, :users
  subject(:user) { described_class.new(id: users(:ben).id, email: users(:ben).email) }

  it "has an email address" do
    expect(subject.email).to eq("ben@gmail.com")
  end
end
