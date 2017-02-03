class TransferController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/transfers/:warehouse_id/new' do
    if logged_in?
      @user = User.find(session[:user_id])
      @warehouse = Warehouse.find_by(:id =>params[:warehouse_id])
      @inventory = Inventory.where(:warehouse_id =>params[:warehouse_id])
      @customer = Customer.where(:user_id =>@user.id)
      erb :'/transfers/create_transfer'
    else
      flash[:message] = "You need to be logged in to access this page."
      redirect "/login"
    end
  end

  post '/transfers/:warehouse_id' do
      @user = User.find(session[:user_id])
      if !params[:transfer].values.any? &:empty? #Unless form is empty
        @customer = Customer.find_by(id: params["transfer"]["customer_id"])
        @inventory = Inventory.find_by(product_id: params["transfer"]["product_id"], warehouse_id: params["warehouse_id"])
        if !(params["transfer"]["quantity"].to_i > @inventory.pallet_count.to_i) #Unless transfer quantity exceeds available inventory
        @transfer = Transfer.create(params[:transfer])
        @transfer.user_id = @user.id
        @transfer.warehouse_id = params[:warehouse_id]
        #Remove quantity from inventory
        @inventory.pallet_count -= @transfer.quantity.to_i
        @inventory.save
        # binding.pry
      else
        flash[:message] = "Error: Transfer quantity exceeds available inventory."
        redirect to "/transfers/#{:warehouse_id}/new"
        # if !Inventory.find_by(product_id: params["inventory"]["product_id"], warehouse_id: params["warehouse_id"]) #if inventory doesn't exist in this warehouse
      #       @inventory = Inventory.create(params[:inventory])
      #       #Inventory belongs to current user
      #       @inventory.user_id = @user.id
      #       #Get the product the user selected
      #       @product = Product.find_by(:id =>@inventory.product_id)
      #       #Set inventory information
      #       @inventory.name = @product.name
      #       @inventory.warehouse_id = params[:warehouse_id]
      #       @inventory.case_count = (@inventory.pallet_count * @product.cases_in_layer * @product.layers_in_pallet)
      #       @inventory.each_count = (@inventory.case_count * @product.each_in_case)
      # else
      #     @inventory = Inventory.find_by(product_id: params["inventory"]["product_id"], warehouse_id: params["warehouse_id"]) #find the existing inventory
      #     @inventory.pallet_count += params["inventory"]["pallet_count"].to_i
      end #if
      flash[:message] = "Successfully transferred #{params['transfer']['quantity'].to_i} #{@inventory.name} pallets to #{@customer.name}."
      @transfer.save
      redirect to "/warehouses/#{params[:warehouse_id]}"
    end #if
  end #do

    helpers do
        def logged_in?
          !!session[:user_id]
        end

        def current_user
          User.find(session[:user_id])
        end
      end #helpers

end #class