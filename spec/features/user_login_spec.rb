require 'rails_helper'

RSpec.feature "User logs in to app", type: :feature, js: true do
  # SETUP
  before :each do
    @user = User.create!({
      first_name: 'Gon',
      last_name: 'Freecss',
      email: 'example@example.com',
      password: 'example',
      password_confirmation: 'example'
    })
  end

  # TEST
  scenario "User logs in with correct credential" do
    visit root_path
    page.click_link('Login')

    expect(page).to have_content 'Log In!'

    page.fill_in 'email', with: 'example@example.com'
    page.fill_in 'password', with: 'example'

    page.click_on('Submit')

    expect(page).to have_content "Hi there, #{@user.first_name}!" && 'Logout'
    
    # DEBUG
    # save_screenshot
  end
end
