class Api::V1::UsersController < ApplicationController

  def index
    @users = User.all
    if @users
      render json: @users, status: 200
    else
      render json: {
        status: 500,
        errors: ['no users found']
      }
    end
  end

  def show
      @user = User.find(params[:id])
     if @user
        render json: @user, status: 200
      else
        render json: {
          status: 500,
          errors: ['user not found']
        }
      end
  end
      
  def create
    @user = User.new(user_params)
    if @user
      token = JsonWebToken.encode({user_id: @user.id})
      render json: @user, {token: token, status: 200}
    else
      render json: {errors: 'invalid username, email, or password', status: :unauthorized}
    end
  end

  private
      
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end