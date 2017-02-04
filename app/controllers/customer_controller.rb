class CustomerController < Sinatra::Base

require 'rack-flash'

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
    use Rack::Flash
  end

  get '/customers/new' do
    if logged_in?
      erb :'/customers/create_customer'
    else
      flash[:message] = "You need to be logged in to access this page."
      redirect "/login"
    end
  end

    post '/customers' do
      @user = current_user
      @customer = Customer.new(params[:customer])
      if @customer.save
        #Customer belongs to current user
         @customer.user_id = @user.id
         redirect to "/customers/#{@customer.id}"
      else #If form is empty
         flash[:message] = "Error: All fields are required!"
         redirect to "/customers/new"
      end #if
    end

    get '/customers/:customer_id' do
       if logged_in?
          @user = current_user
          @customer_id = params[:customer_id]
          @customer = Customer.find_by(id: @customer_id)
          @transfer = Transfer.where(:customer_id => @customer_id)
           erb :'/customers/show_customer'
      else
        flash[:message] = "You need to be logged in to access this page."
        redirect "/login"
      end
    end

     get '/customers/:customer_id/edit' do
        if logged_in?
            @user = current_user
            @customer_id = params[:customer_id]
            @customer = Customer.find_by(id: @customer_id)
            #User can only edit their own customer
            if @customer.user_id == @user.id
                erb :'/customers/edit_customer'
            else
                flash[:message] = "This customer doesn't exist in your account."
                redirect "/dashboard"
            end
        else
          flash[:message] = "You need to be logged in to access this page."
          redirect "/login"
        end
    end

    patch '/customers/:customer_id' do
        @customer_id = params[:customer_id]
        @customer = Customer.find_by(id: @customer_id)
        if @customer.update(params["customer"])
            redirect to "/customers/#{@customer_id}"
        else #Show error if form is empty
            flash[:message] = "All fields are required!"
            redirect to "/customers/#{@customer_id}/edit"
        end
    end

      delete '/customers/:customer_id/delete' do
          if logged_in?
              @user = current_user
              @customer_id = params[:customer_id]
              @customer = Customer.find_by(id: @customer_id)
              #User can only delete their own customer
              if @customer.user_id == @user.id
                  @customer.delete
              else
                  flash[:message] = "This customer doesn't exist in your account."
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