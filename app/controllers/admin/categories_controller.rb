class Admin::CategoriesController < ApplicationController
  # Basic Admin Authenticcation
  http_basic_authenticate_with name: ENV['ADMIN_BASIC_AUTH_USERNAME'], password: ENV['ADMIN_BASIC_AUTH_PASSWORD']

  def index
  end

  def new
  end

  def create
  end
end
