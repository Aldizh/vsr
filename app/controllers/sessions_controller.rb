class SessionsController < ApplicationController
  def new
    if session[:current_reseller3_id]
      redirect_to '/reseller3s'
    end
    if session[:current_reseller2_id]
      redirect_to '/reseller2s'
    end
    if session[:current_reseller1_id]
      redirect_to '/reseller1s'
    end
    if session[:current_client_id]
      redirect_to '/clients'
    end
  end

  def create
    reseller3 = Reseller3.authenticate(params[:login], params[:password])
    reseller2 = Reseller2.authenticate(params[:login], params[:password])
    reseller1 = Reseller1.authenticate(params[:login], params[:password])
    client = Client.authenticate(params[:login], params[:password])
    if reseller3
      session[:current_reseller3_id] = reseller3[:id]
      session[:current_reseller3_login] = reseller3[:login]
      session[:password] = reseller3[:password]
      flash[:notice] = "You are successfuly logged in!"
      redirect_to '/reseller3s'
    elsif reseller2
      session[:current_reseller2_id] = reseller2[:id]
      session[:current_reseller2_login] = reseller2[:login]
      session[:password] = reseller2[:password]
      flash[:notice] = "You are successfuly logged in!"
      redirect_to '/reseller2s'
    elsif reseller1
      session[:current_reseller1_id] = reseller1[:id]
      session[:current_reseller1_login] = reseller1[:login]
      session[:password] = reseller1[:password]
      flash[:notice] = "You are successfuly logged in!"
      redirect_to '/reseller1s'
    elsif client
      session[:current_client_id] = client[:id_client]
      session[:current_client_login] = client[:login]
      session[:password] = client[:password]
      flash[:notice] = "You are successfuly logged in!"
      redirect_to '/clients'
    else
      flash[:error] = "Wrong Login or Password!"
      redirect_to '/sessions/new'
    end
  end

  def destroy
  	reset_session
    flash[:notice] = "You are successfuly logged out!"
  	redirect_to '/sessions/new'
  end
end
