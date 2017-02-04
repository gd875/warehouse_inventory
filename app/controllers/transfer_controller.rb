class TransferController < Sinatra::Base

require 'rack-flash'

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
    use Rack::Flash
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
      @transfer = Transfer.new(params[:transfer])
      if @transfer.save
        @customer = Customer.find_by(id: params["transfer"]["customer_id"])
        @inventory = Inventory.find_by(product_id: params["transfer"]["product_id"], warehouse_id: params["warehouse_id"])
        if !(params["transfer"]["quantity"].to_i > @inventory.pallet_count.to_i) #Unless transfer quantity exceeds available inventory

        @transfer.user_id = @user.id
        @transfer.warehouse_id = params[:warehouse_id]
        #Remove quantity from inventory
        @inventory.pallet_count -= @transfer.quantity.to_i
        @inventory.save
        # binding.pry
      else
        flash[:message] = "Error: Transfer quantity exceeds available inventory."
        redirect to "/transfers/#{params[:warehouse_id]}/new"
      end #If transfer exceeds available inventory
      flash[:message] = "Successfully transferred #{params['transfer']['quantity'].to_i} #{@inventory.name} pallets to #{@customer.name}."
      @transfer.save
      redirect to "/warehouses/#{params[:warehouse_id]}"
    else #Show error if form is empty
      flash[:message] = "All fields are required!"
      redirect to "/transfers/#{params[:warehouse_id]}/new"
    end #if form is empty
  end #do

#There are no edit or delete routes because orders can't be cancelled or modified once the warehouse sends it out to the customer.

    helpers do
        def logged_in?
          !!session[:user_id]
        end

        def current_user
          User.find(session[:user_id])
        end
      end #helpers

end #class