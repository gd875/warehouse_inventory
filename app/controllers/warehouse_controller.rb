class WarehouseController < Sinatra::Base

require 'rack-flash'

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
    use Rack::Flash
  end

  get '/warehouses/new' do
    if logged_in?
      erb :'/warehouses/create_warehouse'
    else
      redirect "/login"
    end
  end

  post '/warehouses' do
      @warehouse = Warehouse.create(params[:warehouse])
      flash[:message] = "Successfully created warehouse."
      redirect to "/dashboard"
  end

  get '/warehouses/:warehouse_id' do
     if logged_in?
        @warehouse_id = params[:warehouse_id]
        @warehouse = Warehouse.find_by(id: @warehouse_id)
         erb :'/warehouses/show_warehouse'
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