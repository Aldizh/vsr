require 'net/http'
require 'json'
require 'rest_client'
class Resellers3Controller < ApplicationController  

  def index
    
  end

  def getMyDetails
    @url = "http://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller3_login]}"
    @password = "#{session[:password]}"
    puts "HELOOOOOOOOO AGAIN"
    puts @login
    puts @password


    #resource = RestClient::Resource.new @url#, "authentication-point/authenticate"
    #resource = RestClient::Request.new(:method => :head, :url => @url)
    #resource.head :Authorization => Base64.encode64(@login) + ":" + Base64.encode64(@password)
    #response = resource.get
    #puts response
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

    @result = JSON.parse(@response.to_s)
    
  end
end
