class WelcomeController < ApplicationController
	respond_to :js, :json, :html, :xml

	def index
	end

	def register
		@new_reg = "New Register"
		respond_with @new_reg
	end


end
