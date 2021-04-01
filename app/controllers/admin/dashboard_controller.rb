class Admin::DashboardController < ApplicationController
  # Basic Admin Authenticcation
  http_basic_authenticate_with name: ENV['ADMIN_BASIC_AUTH_USERNAME'], password: ENV['ADMIN_BASIC_AUTH_PASSWORD']
  
  def show
    @products_count = Product.count
    @categories_count = Category.count
  end
end
