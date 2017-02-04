class ProductController < Sinatra::Base

require 'rack-flash'

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
    use Rack::Flash
  end

  get '/products/new' do
    if logged_in?
      erb :'/products/create_product'
    else
      flash[:message] = "You need to be logged in to access this page."
      redirect "/login"
    end
  end

  post '/products' do
      @user = current_user
      @product = Product.new(params[:product])
      if @product.save #Form can't be empty
        #Warehouse belongs to current user
        @product.user_id = @user.id
        @product.save
        redirect to "/products/#{@product.id}"
      else #If form is empty
        flash[:message] = "Error: All fields are required!"
        redirect to "/products/new"
      end
  end

  get '/products/:product_id' do
     if logged_in?
        @user = current_user
        @product_id = params[:product_id]
        @product = Product.find_by(id: @product_id)
         erb :'/products/show_product'
    else
      flash[:message] = "You need to be logged in to access this page."
      redirect "/login"
    end
  end

     get '/products/:product_id/edit' do
          if logged_in?
              @user = current_user
              @product_id = params[:product_id]
              @product = Product.find_by(id: @product_id)
              #User can only edit their own warehouse
              if @product.user_id == @user.id
                  erb :'/products/edit_product'
              else
                  flash[:message] = "This product doesn't exist in your account."
                  redirect "/dashboard"
              end
          else
            flash[:message] = "You need to be logged in to access this page."
            redirect "/login"
          end
      end

    patch '/products/:product_id' do
        @product_id = params[:product_id]
        @product = Product.find_by(id: @product_id)
        if @product.user_id == current_user.id
            if @product.update(params["product"]) #Form cannot be empty
                redirect to "/products/#{@product_id}"
            else
                flash[:message] = "Error: All fields are required!"
                redirect to "/products/#{@product_id}/edit"
            end
        else
            flash[:message] = "This product doesn't exist in your account."
            redirect "/dashboard"
        end
    end

      delete '/products/:product_id/delete' do
          if logged_in?
              @product_id = params[:product_id]
              @product = Product.find_by(id: @product_id)
              #User can only delete their own product
              if @product.user_id == current_user.id
                  @product.delete
              else
                  flash[:message] = "This product doesn't exist in your account."
                  redirect "/dashboard"
              end
          else
            flash[:message] = "You need to be logged in to access this page."
            redirect "/login"
          end
          redirect to "/dashboard"
      end

    helpers do
        def logged_in?
          !!current_user
        end

        def current_user
          @current_user ||= User.find(session[:user_id]) if session[:user_id]
        end
      end #helpers

end #class