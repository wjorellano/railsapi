class Api::V1::SessionsController < Devise::SessionsController
   before_action :sign_in_params, only: :create
   before_action :load_user, only: :create
   before_action :valid_token, only: :destroy
   skip_before_action :verify_signed_out_user, only: :destroy

   # sign in
   def create
      if @user.valid_password?(sign_in_params[:password])
         sign_in "user", @user
         json_response "Signed In Successfully", true, {user: @user}, :ok
      else
         json_response "Unauthorized", false, {}, :unauthorized
      end
   rescue StandardError => e
      json_response e.message, false, {}, :internal_server_error
   end

   # logout
   def destroy
      sign_out @user
      if @user.generate_new_authentication_token
         json_response "Log out Successfully", true, {}, :ok
      else
         json_response "Invalid Token", false, {}, :internal_server_error
      end
   rescue StandardError => e
      json_response e.message, false, {}, :internal_server_error
   end

   private

   def sign_in_params
      params.require(:sign_in).permit(:login, :password)
   end

   def load_user
      @user = User.find_for_database_authentication(login: sign_in_params[:login])
      if @user
        return @user
      else
         json_response "Cannot get User", false, {}, :internal_server_error
      end
   end

   def valid_token
      @user = User.find_by authentication_token: request.headers["AUTH-TOKEN"]
      if @user
         return @user
      else
         json_response "Invalid Token", false, {}, :internal_server_error
      end
   end
end