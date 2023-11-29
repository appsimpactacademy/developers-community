class PasswordsController < ApplicationController
	before_action :require_user_logged_in
	
	def edit
	end
	
	def update
		if current_user.update(password_params)
			redirect_to root_path, notice: 'Password Updated!'
		else
			render :edit
		end
	end
	
	private
	
	def require_user_logged_in
		redirect_to sign_in_path, alert: "You must be signed in to do that." if current_user.nil?
	end
	
	def password_params
		params.require(:user).permit(:password, :password_confirmation)
	end
end