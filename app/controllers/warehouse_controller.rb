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
      flash[:message] = "You need to be logged in to access this page."
      redirect "/login"
    end
  end

  post '/warehouses' do
      @user = User.find(session[:user_id])
      @warehouse = Warehouse.new(params[:warehouse])
      if @warehouse.save #Form can't be empty
        #Warehouse belongs to current user
        @warehouse.user_id = @user.id
        @warehouse.save
        redirect to "/warehouses/#{@warehouse.id}"
      else #If form is empty
        flash[:message] = "Error: All fields are required!"
        redirect to "/warehouses/new"
      end
  end

  get '/warehouses/:warehouse_id' do
     if logged_in?
        @user = User.find(session[:user_id])
        @warehouse_id = params[:warehouse_id]
        @warehouse = Warehouse.find_by(id: @warehouse_id)
        #Hides inventory from warehouse page when qualtity reaches 0
        @inventory = Inventory.where("warehouse_id = #{@warehouse_id} AND pallet_count > 0")
         erb :'/warehouses/show_warehouse'
         # binding.pry
    else
      flash[:message] = "You need to be logged in to access this page."
      redirect "/login"
    end
  end

   get '/warehouses/:warehouse_id/edit' do
          if logged_in?
              @user = User.find(session[:user_id])
              @warehouse_id = params[:warehouse_id]
              @warehouse = Warehouse.find_by(id: @warehouse_id)
              #User can only edit their own warehouse
              if @warehouse.user_id == @user.id
                  erb :'/warehouses/edit_warehouse'
              else
                  flash[:message] = "This warehouse doesn't exist in your account."
                  redirect "/dashboard"
              end
          else
            flash[:message] = "You need to be logged in to access this page."
            redirect "/login"
          end
      end

    patch '/warehouses/:warehouse_id' do
        @warehouse_id = params[:warehouse_id]
        @warehouse = Warehouse.find_by(id: @warehouse_id)
        if @warehouse.update(params["warehouse"]) #Update form can't be empty
            redirect to "/warehouses/#{@warehouse_id}"
        else
            flash[:message] = "Error: All fields are required!"
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
                  flash[:message] = "This warehouse doesn't exist in your account."
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
          !!session[:user_id]
        end

        def current_user
          User.find(session[:user_id])
        end
      end #helpers

end #class