class SessionsController < ApplicationController
  def new
  end

  def create
    reseller3 = Reseller3.authenticate(params[:login], params[:password])
    if reseller3
      session[:current_reseller3_id] = reseller3[:id]
      session[:current_reseller3_login] = reseller3[:login]
      session[:password] = reseller3[:password]
      redirect_to '/reseller3s'
    else
      flash[:error] = "Wrong Login or Password!"
      redirect_to '/sessions/new'
    end
  end

  def destroy
  	reset_session
  	redirect_to '/sessions/new'
  end
end
