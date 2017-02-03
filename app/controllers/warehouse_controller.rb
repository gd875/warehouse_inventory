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
      @user = User.find(session[:user_id])
      @warehouse = Warehouse.create(params[:warehouse])
      #Warehouse belongs to current user
      @warehouse.user_id = @user.id
      @warehouse.save
      flash[:message] = "Successfully created #{@warehouse.name} warehouse."
      redirect to "/dashboard"
  end

  get '/warehouses/:warehouse_id' do
     if logged_in?
        @user = User.find(session[:user_id])
        @warehouse_id = params[:warehouse_id]
        @warehouse = Warehouse.find_by(id: @warehouse_id)
        @inventory = Inventory.where(:warehouse_id =>@warehouse_id)
         erb :'/warehouses/show_warehouse'
    else
      redirect "/login"
    end
  end

   get '/warehouses/:warehouse_id/edit' do
          if logged_in?
              @user = User.find(session[:user_id])
              @warehouse_id = params[:warehouse_id]
              @warehouse = Warehouse.find_by(id: @warehouse_id)
              # erb :'/warehouses/edit_warehouse' #Anyone can edit
              #User can only edit their own warehouse
              if @warehouse.user_id == @user.id
                  erb :'/warehouses/edit_warehouse'
              else
                  redirect "/dashboard"
              end
          else
            redirect "/login"
          end
      end

    patch '/warehouses/:warehouse_id' do
        @warehouse_id = params[:warehouse_id]
        @warehouse = Warehouse.find_by(id: @warehouse_id)
        if !params["warehouse"].empty?
            @warehouse.update(params["warehouse"])
            redirect to "/warehouses/#{@warehouse_id}"
        else
            redirect to "/warehouses/#{@warehouse_id}/edit"
        end
    end

    delete '/warehouses/:warehouse_id/delete' do
          if logged_in?
              @user = User.find(session[:user_id])
              @warehouse_id = params[:warehouse_id]
              @warehouse = Warehouse.find_by(id: @warehouse_id)
              # @warehouse.delete #Anyone logged in can delete
              #User can only delete their own warehouse
              if @warehouse.user_id == @user.id
                  @warehouse.delete
              else
                  redirect "/dashboard"
              end
          else
            redirect "/login"
          end
          redirect to "/dashboard"
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