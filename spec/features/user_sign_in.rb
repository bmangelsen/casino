require 'rails_helper'

RSpec.feature "User sign in" do
  it "signs me in" do
    visit '/'
    click_link 'Sign In'
    fill_in 'Email', with: 'ben@gmail.com'
    fill_in 'Password', with: 'password'
    click_button 'Log in'
    expect(page).to have_content 'Signed in successfully'
  end
end
