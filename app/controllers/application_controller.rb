class ApplicationController < Sinatra::Base

require 'rack-flash'

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
    use Rack::Flash
  end

    get "/" do
        if logged_in?
            redirect "/dashboard"
        else
            erb :index
        end
    end

      get "/dashboard" do
        if logged_in?
          # @user = User.find(session[:user_id])
          @user = current_user
          # Display only the user's warehouses
          @warehouse = Warehouse.where(:user_id =>@user.id)
          # Display only the user's products
          @product = Product.where(:user_id =>@user.id)
          # Display only the user's customers
          @customer = Customer.where(:user_id =>@user.id)
          erb :"/users/dashboard"
        else
          redirect "/login"
        end
      end

    helpers do
        def logged_in?
          !!session[:user_id]
        end

        def current_user
          # User.find(session[:user_id])
          @current_user ||= User.find(session[:user_id]) if session[:user_id]
        end
      end #helpers

end #class