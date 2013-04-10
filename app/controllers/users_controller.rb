class UsersController < ApplicationController
	respond_to :js, :json, :html, :xml

	def show
		@user = User.find(params[:id])
	end

  def new
		@user = User.new
  end

	def create
    @user = User.new(params[:user])
    if @user.save
      # Handle a successful save.
			#flash[:success] = "Successfully signed up!"
			respond_with @user
    else
      render 'new'
    end
  end

end
