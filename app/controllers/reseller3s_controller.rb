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
    @myResellers = DB[:resellers2].where(:idReseller => session[:current_reseller3_id])
    res = params[:resellers3]
    puts res
    respond_to do |format|
      format.html
        format.json { render json: @myResellers }
    end
  end

  def addPayment
    @payment = params[:payment_amount]
    @hash = params[:resellers3]
    #puts @hash.is_a?(Hash)
    @login = hash["login"] rescue nil
    puts @login
    @myReseller = DB[:resellers2].where(:login => @login)
    #@type = 0
    puts "BLAAAAAA"
    puts @myReseller[:type]
    @myReseller.each do |reseller|
      @type = reseller[:type]
      puts @type
    end
    
  end

  def show
    
  end

end
