require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do

    context 'given name, price, quantity, and category' do
      it 'saves successfully' do
        @category = Category.new
        @product = Product.new(name: 'Bluetooth headphones', price: 48999, quantity: 23, category: @category)
        expect(@product).to be_valid
      end
    end

    context 'given only price, quantity, and category' do
      it 'requires a name' do
        @category = Category.new
        @product = Product.new(price: 48999, quantity: 23, category: @category)
        expect(@product).not_to be_valid
        expect(@product.errors.full_messages).to include("Name can't be blank")
      end
    end

    context 'given only name, quantity, and category' do
      it 'requires a price' do
        @category = Category.new
        @product = Product.new(name: 'Bluetooth headphones', quantity: 23, category: @category)
        expect(@product).not_to be_valid
        expect(@product.errors.full_messages).to include("Price can't be blank")
      end
    end
      
    context 'given only name, price, and quantity' do
      it 'requires a category' do
        @product = Product.new(name: 'Bluetooth headphones', price: 48999, quantity: 23)
        expect(@product).not_to be_valid
        expect(@product.errors.full_messages).to include("Category can't be blank")
      end
    end
    
  end
end
