require 'rails_helper'

RSpec.feature "Visitor navigates to product page", type: :feature, js: true do
  # SETUP
  before :each do
    @category = Category.create! name: 'Apparel'

    10.times do |n|
      @category.products.create!(
        name:  Faker::Hipster.sentence(3),
        description: Faker::Hipster.paragraph(4),
        image: open_asset('apparel1.jpg'),
        quantity: 10,
        price: 64.99
      )
    end
  end

  scenario "They see product details navigating from home page" do
    # ACT
    visit root_path
    page.first('article.product').click_link('Details')

    # DEBUG
    # save_screenshot

    # VERIFY
    within('header') { expect(page).not_to have_content('Products') }
    within('header') { expect(page).to have_content(@category.name) }
    expect(page).to have_css 'article.product-detail'

    # save_screenshot
  end

end
