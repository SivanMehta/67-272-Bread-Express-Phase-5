class UsersController < ApplicationController

    # before_action :check_login, only: [:edit, :update]
    authorize_resource

    def index
        @users = User.all.alphabetical.paginate(page: params[:page]).per_page(7)
    end

    def show
        @user = User.find(params[:id])

        if @user.role? :customer # if you are looking at a customer
            redirect_to @user.customer
        end
    end

    def new
        @user = User.new
        session[:user_id] = @user.id
    end

    def edit
        @user = User.find(params[:id])
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
        @user = User.find(params[:id])
        if @user.update_attributes(user_params)
            redirect_to(@user, :notice => '#{@user.username} was successfully updated.')
        else
            render :action => "edit"
        end
    end

    def destroy
        @user = User.find(params[:id])
        if !@user.is_destroyable?
            flash[:error] = "Could not deactivate an already shipped item"
            redirect_to :back
        else
            @user.destroy
            @user.active = false
            @user.save!
            redirect_to items_path, notice: "The #{@item.name} was deactivated from the system."
        end
    end

    private
        def user_params
            params.require(:user).permit(:username, :role, :password, :password_confirmation)
        end
end