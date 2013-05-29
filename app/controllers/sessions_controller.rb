class SessionsController < ApplicationController
  def new
  end

  def create
    reseller3 = Reseller3.authenticate(params[:login], params[:password])
    reseller2 = Reseller2.authenticate(params[:login], params[:password])
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
