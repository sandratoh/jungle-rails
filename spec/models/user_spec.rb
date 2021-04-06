require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    
    context 'given name, email, password, and matching password_confirmation input fields' do
      it 'should save successfully' do
        @user = User.new(name: 'Michael', email: 'michael@test.com', password: 'test', password_confirmation: 'test')
        expect(@user).to be_valid
      end
    end

    context 'given missing name, email, password, or matching password input fields' do
      it 'should require name' do
        @user = User.new(email: 'michael@test.com', password: 'test', password_confirmation: 'test')
        expect(@user).not_to be_valid
        expect(@user.errors.full_messages).to include("Name can't be blank")
      end

      it 'should require email' do
        @user = User.new(name: 'Michael', password: 'test', password_confirmation: 'test')
        expect(@user).not_to be_valid
        expect(@user.errors.full_messages).to include("Email can't be blank")
      end

      it 'should require password' do
        @user = User.new(name: 'Michael', email: 'michael@test.com')
        expect(@user).not_to be_valid
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end

      it 'should require matching password confirmation' do
        @user = User.new(name: 'Michael', email: 'michael@test.com', password: 'test', password_confirmation: 'wrongpassword')
        expect(@user).not_to be_valid
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
    end

    context 'user email input' do
      before do
        @user = User.create(name: 'Michael', email: 'michael@test.com', password: 'test', password_confirmation: 'test')
      end

      it 'should not save if exact email already exists in database' do
        @new_user = User.new(name: 'Michael', email: 'michael@test.com', password: 'test', password_confirmation: 'test')
        expect(@new_user).not_to be_valid
        expect(@new_user.errors.full_messages).to include("Email has already been taken")
      end

      it 'should be unique and not case sensitive' do
        @new_user = User.new(name: 'Michael', email: 'michael@test.COM', password: 'test', password_confirmation: 'test')
        expect(@new_user).not_to be_valid
        expect(@new_user.errors.full_messages).to include("Email has already been taken")
      end
    end

    context 'password input' do
      it 'should have a minimum length of 4' do
        @user = User.new(name: 'Michael', email: 'michael@test.COM', password: 'abc', password_confirmation: 'abc')
        expect(@user).not_to be_valid
      end
    end

  end

  describe '.authenticate_with_credentials' do
    before do
      User.create(name: 'Michael', email: 'michael@dundermifflin.com', password: 'test', password_confirmation: 'test')
      @email = 'michael@dundermifflin.com'
      @password = 'test'
    end

    context 'with correct authentication input' do
      it 'should log user in' do
        @user_login = User.authenticate_with_credentials(@email, @password)
        expect(@user_login).not_to be_nil
      end
    end

    context 'with nonexisting email' do
      it 'should not log user in' do
        @email = 'michael@wrongemail.com'
        @user_login = User.authenticate_with_credentials(@email, @password)
        expect(@user_login).to be_falsey
      end
    end

    context 'with incorrect password' do
      it 'should not log user in' do
       @password = 'TEST'
       @user_login = User.authenticate_with_credentials(@email, @password)
       expect(@user_login).to be_falsey
      end
    end

    context 'with non-case-sensitive email' do
      it 'should log user in' do
        @email = 'MICHAEL@dundermifflin.com'
        @user_login = User.authenticate_with_credentials(@email, @password)
        expect(@user_login).not_to be_nil
      end
    end

    context 'with whitespaces before email' do
      it 'should log user in' do
        @email = '  michael@dundermifflin.com'
        @user_login = User.authenticate_with_credentials(@email, @password)
        expect(@user_login).not_to be_nil
      end
    end

  end
end
