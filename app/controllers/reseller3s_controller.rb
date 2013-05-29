require 'net/http'
require 'json'
require 'rest_client'
class Reseller3sController < ApplicationController  

  def index

    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller3_login]}"
    @password = "#{session[:password]}"

    @data = {
      "jsonrpc" => "2.0",
      "id" => 1,
      "method" => "getMyDetails",
      "params" => {}
    }.to_json


    @response = RestClient::Request.new(
      :method => :post,
      :payload => @data,
      :url => @url,
      :user => @login,
      :password => @password,
      :headers => { :accept => :json, :content_type => :json}).execute

    @result = ActiveSupport::JSON.decode(@response)  

  end

  def viewMyResellers
    #puts "DAMNNNNNNNNNNNNNN"
    @myResellers = DB[:resellers2].where(:idReseller => session[:current_reseller3_id])
    respond_to do |format|
      format.html
        format.json { render json: @myResellers }
    end
  end

  def addPayment
  end

  def show
    
  end

end
