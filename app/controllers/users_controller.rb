class UsersController < ApplicationController

    # before_action :check_login, only: [:edit, :update]
    # authorize_resource

    def new
        @user = User.new
        session[:user_id] = @user.id
    end

    def edit
        @user = User.find(params[current_user])
    end

    def create
        @user = User.new(user_params)
        if @user.save
            redirect_to(@user, :notice => 'User was successfully created.')
        else
            render :action => "new"
        end
    end

    def update
        @update = User.find(params[current_user])
        if @user.update_attributes(user_params)
            redirect_to(@user, :notice => 'User was successfully updated.')
        else
            render :action => "edit"
        end
    end

    private
        def user_params
            params.require(:user).permit(:first_name, :last_name, :email, :role, :band_id, :password, :password_confirmation)
        end
end