class CustomerController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
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
      @user = User.find(session[:user_id])
      # binding.pry
      if !params[:customer].values.any? &:empty? #Unless form is empty
        @customer = Customer.create(params[:customer])
        #Customer belongs to current user
        @customer.user_id = @user.id
        @customer.save
        flash[:message] = "Successfully created customer #{@customer.name}."
        redirect to "/dashboard"
      else #If form is empty
        flash[:message] = "All fields are required!"
        redirect to "/customers/new"
      end #if
    end

    get '/customers/:customer_id' do
       if logged_in?
          @user = User.find(session[:user_id])
          @customer_id = params[:customer_id]
          @customer = Customer.find_by(id: @customer_id)
          # @inventory = Inventory.where(:warehouse_id =>@warehouse_id)
           erb :'/customers/show_customer'
           # binding.pry
      else
        flash[:message] = "You need to be logged in to access this page."
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