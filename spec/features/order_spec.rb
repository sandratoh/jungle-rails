require 'rails_helper'

RSpec.feature "After creation", type: :feature, js: true do
  before :each do
    @category = Category.create! name: 'Utilities'

    @product1 = @category.products.create!(
      name: 'Lettuce Chopper',
      description: Faker::Hipster.paragraph(4),
      image: open_asset('apparel1.jpg'),
      quantity: 3,
      price: 6499
    )

    @product2 = @category.products.create!(
      name: 'Vitamin Blender',
      description: Faker::Hipster.paragraph(4),
      image: open_asset('apparel1.jpg'),
      quantity: 6,
      price: 6499
    )

    @product3 = @category.products.create!(
      name: 'Kneeling Cushion',
      description: Faker::Hipster.paragraph(4),
      image: open_asset('apparel1.jpg'),
      quantity: 10,
      price: 6499
    )
  end

  scenario 'deducts quantity from products based on their line item quantities' do
    # 1. initialize order with necessary fields (see orders_controllers, schema and model definition for what is required)
    @order = Order.new(
      id: 22,
      email: 'test@test.com',
      stripe_charge_id: 1234
    )

    # puts @order.inspect
    # 2. build line items on @order
    @line_item1 = @order.line_items.new(
      order_id: @order[:id],
      product_id: @product1[:id],
      quantity: 3,
      item_price_cents: 6499,
      total_price_cents: 3 * 6499
    )

    @line_item2 = @order.line_items.new(
      order_id: @order[:id],
      product_id: @product2[:id],
      quantity: 4,
      item_price_cents: 6499,
      total_price_cents: 4 * 6499
    )

    @order.total_cents = @line_item1.total_price_cents + @line_item2.total_price_cents

    # 3. save! the order - ie raise an exception if it fails (not expected)
    @order.save!
    @line_item1.save!
    @line_item2.save!
    
    # 4. reload products to have their updated quantities
    @product1.reload
    @product2.reload
    # 5. use RSpec expect syntax to assert their new quantity values
    expect(@product1.quantity).to eql(0)
    expect(@product2.quantity).to eql(2)
  end
  
  scenario 'does not deduct quantity from products that are not in the order' do
    # 1. initialize order with necessary fields (see orders_controllers, schema and model definition for what is required)
    @order = Order.new(
      id: 22,
      email: 'test@test.com',
      stripe_charge_id: 1234
    )

    # 2. build line items on @order
    @line_item1 = @order.line_items.new(
      order_id: @order[:id],
      product_id: @product1[:id],
      quantity: 3,
      item_price_cents: 6499,
      total_price_cents: 3 * 6499
    )

    @order.total_cents = @line_item1.total_price_cents

    # 3. save! the order - ie raise an exception if it fails (not expected)
    @order.save!
    @line_item1.save!
    
    # 4. reload products to have their updated quantities
    @product3.reload
    expect(@product3.quantity).to eql(10)
  end
end
