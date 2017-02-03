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
        erb :index
    end

     get "/signup" do
         if logged_in?
            redirect "/dashboard"
         else
             erb :"/users/create_user"
         end
    end #signup

      post "/signup" do
        user = User.new(:username => params[:username], :password => params[:password])
        if user.save
          session[:user_id] = user.id
          redirect "/dashboard"
        else
          redirect "/signup"
        end
      end

      get "/dashboard" do
        if logged_in?
          @user = User.find(session[:user_id])
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

      get "/login" do
         if logged_in?
          redirect "/dashboard"
        else
          erb :"/users/login"
        end
      end

      post "/login" do
        user = User.find_by(:username => params[:username])
        if user && user.authenticate(params[:password])
          session[:user_id] = user.id
          redirect "/dashboard"
        else
          redirect "/login"
        end
      end

      get "/logout" do
         if logged_in?
             session.clear
             redirect "/login"
        else
          redirect "/"
        end
      end

    helpers do
        def logged_in?
          !!session[:user_id]
        end

        def current_user
          User.find(session[:user_id])
        end
      end #helpers

end #class