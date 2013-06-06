require 'net/http'
require 'json'
require 'rest_client'
class Reseller3sController < ApplicationController  

  def index

    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller3_login]}"
    @password = "#{session[:password]}"

    start_date = "01-01-2009"
    end_date = "07-08-2013"#to be changed later
    @total_revenue = 0
    @total_cost = 0

    @data1 = {
      "jsonrpc" => "2.0",
      "id" => 1,
      "method" => "getMyDetails",
      "params" => {}
    }.to_json
    
    @data2 = {
    "jsonrpc" => "2.0",
    "id" => 1,
    "method" => "getMyPaymentsHistory",
    "params" => {
        "filter" => {
            "dateFrom" => start_date,
            "dateTo" => end_date,
            "moneyFrom" => 0,
            "moneyTo" => 10
        },
        "paging" => {
            "pageNumber" => 0,
            "pageSize" => 100,
            "sortColumn" => "date",
            "descending" => false
        }
      }
    }.to_json
    
    @response1 = RestClient::Request.new(
      :method => :post,
      :payload => @data1,
      :url => @url,
      :user => @login,
      :password => @password,
      :headers => { :accept => :json, :content_type => :json}).execute

    @result1 = ActiveSupport::JSON.decode(@response1)

    @response2 = RestClient::Request.new(
      :method => :post,
      :payload => @data2,
      :url => @url,
      :user => @login,
      :password => @password,
      :headers => { :accept => :json, :content_type => :json}).execute

    @result2 = ActiveSupport::JSON.decode(@response2)

    i = 0
    while i < @result2["result"]["totalCount"]
      @result2["result"]["records"].each do |c|
        @total_cost += c["amount"]
      end
      i += 1
    end

    #calculate profit
    @clients = DB[:resellers2].where(:idReseller => session[:current_reseller3_id])
    @clients.each do |r|
      @res = payment_history(r[:login])
      @res["result"]["records"].each do |c|
        @total_revenue += c["amount"]
      end
    end
  
    @profit = @total_revenue - @total_cost
    puts "PROOOOOOO"
    puts @profit
  end

  def payment_history(login=nil)

    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller3_login]}"
    @password = "#{session[:password]}"
    if login
      client_login = login
    else
      client_login = params[:login]
    end
    client_id = params[:id]

    @data = {
    "jsonrpc" => "2.0",
    "id" => 1,
    "method" => "getClientPaymentsHistory",
    "params" => {
        "login" => client_login,
        "clientType" => "Reseller",
        "filter" => {
            "dateFrom" => "2013-05-01",
            "dateTo" => "2013-06-06",
            "moneyFrom" => 0,
            "moneyTo" => 20
    },
            "paging" => {
            "pageNumber" => 0,
            "pageSize" => 100,
            "sortColumn" => "date",
            "descending" => true
            }
      }
    }.to_json

    
    @response = RestClient::Request.new(
      :method => :post,
      :payload => @data,
      :url => @url,
      :user => @login,
      :password => @password,
      :headers => { :accept => :json, :content_type => :json}).execute

    @result = ActiveSupport::JSON.decode(@response)  
    return @result
  end

  def viewMyResellers
    @myResellers = DB[:resellers2].where(:idReseller => session[:current_reseller3_id])
    res = params[:resellers3]
    puts res
        puts @myResellers.all

    respond_to do |format|
      format.html
        format.json { render json: @myResellers }
    end
    return @myResellers
  end

  def addPayment

    temp_payment = params[:payment_amount]
    payment_note = params[:payment_note]
    payment = temp_payment.to_f #changed payment to float
    temp_hash = params[:resellers3]
    login = temp_hash["login"] rescue nil


    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller3_login]}"
    @password = "#{session[:password]}"


    @data = { 
      "jsonrpc" => "2.0", 
      "id" => 1, 
      "method" => "doClientPayment", 
      "params" => { 
        "login" => login, 
        "clientType" => "Reseller", 
        "payment" => { 
          "paymentType" => "Payment", 
          "amount" => payment, 
          "description" => payment_note
          } 
        }
    }.to_json

    @response = RestClient::Request.new(
      :method => :post,
      :payload => @data,
      :url => @url,
      :user => @login,
      :password => @password,
      :headers => { :accept => :json, :content_type => :json}).execute

    @result = ActiveSupport::JSON.decode(@response) 


    if @result["error"] 
      flash[:error_payment] = "Payment did not go through. Please try again!"
    else 
      flash[:notice_payment] = "Payment added successfully!"
    end

    redirect_to "/reseller3s/viewMyResellers"

    
  end

  def show
    
  end

end
