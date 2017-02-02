class ProductController < Sinatra::Base

require 'rack-flash'

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/products/new' do
    if logged_in?
      erb :'/products/create_product'
    else
      redirect "/login"
    end
  end

  post '/products' do
      @user = User.find(session[:user_id])
      @product = Product.create(params[:product])
      #Warehouse belongs to current user
      @product.user_id = @user.id
      @product.save
      flash[:message] = "Successfully created product."
      redirect to "/dashboard"
  end

  get '/products/:product_id' do
     if logged_in?
        @user = User.find(session[:user_id])
        @product_id = params[:product_id]
        @product = Product.find_by(id: @product_id)
         erb :'/products/show_product'
    else
      redirect "/login"
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