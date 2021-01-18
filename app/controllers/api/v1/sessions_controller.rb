class Api::V1::SessionsController < ApplicationController
    skip_before_action :authorized, only: [:create]

    def create
        if params[:email]
            @user = User.find_by(params[:email])
        else
            @user = User.find_by(params[:username])
        end

        if @user && @user.authenticate(params[:password])
            payload = {user_id: @user.id}
            token = JsonWebToken.encode(payload)
            render json: {@user, token: token}
        else
            render json: {errors: 'invalid credentials'}, status: :unauthorized
        end
    end

    def autologin
        token = JsonWebToken.encode({user_id: current_user.id})
        render json: {user: current_user, token: token}
    end

end