class InventoryController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/inventory/:warehouse_id/new' do
    if logged_in?
      @user = User.find(session[:user_id])
      @warehouse = Warehouse.find_by(:id =>params[:warehouse_id])
      @product = Product.where(:user_id =>@user.id)
      erb :'/inventory/create_inventory'
    else
      redirect "/login"
    end
  end

  post '/inventory/:warehouse_id' do
      @user = User.find(session[:user_id])
      @inventory = Inventory.create(params[:inventory])
      #Inventory belongs to current user
      @inventory.user_id = @user.id
      @product = Product.find_by(:id =>@inventory.product_id)
      @inventory.name = @product.name
      @inventory.warehouse_id = params[:warehouse_id]
      @inventory.case_count = (@inventory.pallet_count * @product.cases_in_layer * @product.layers_in_pallet)
      @inventory.each_count = (@inventory.case_count * @product.each_in_case)
      @inventory.save
      flash[:message] = "Successfully created inventory."
      redirect to "/warehouses/#{params[:warehouse_id]}"
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