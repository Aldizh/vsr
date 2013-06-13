require 'net/http'
require 'json'
require 'rest_client'
class Reseller1sController < ApplicationController  

  def index
    @total_profit = 0
    @my_clients = DB[:clientsshared].where(:id_reseller => session[:current_reseller1_id])
    @calls = []
    @my_clients.each do |client|
      @calls.push(DB[:calls].where(:id_client => client[:id_client]))
    end
    @calls.each do |call|
      call.each do |c|
        @total_profit += (c[:cost] - c[:costD])
      end
    end
    #puts prefix_match("1234", "123456")

    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller1_login]}"
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



  def payment_history

    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller1_login]}"
    @password = "#{session[:password]}"
    client_login = params[:login]
    client_id = params[:id]
    session[:client_login] = client_login
    
    today = Time.new
    date = (today.to_s).split(" ")
    date_to = date[0]
    date_comps = date_to.split("-")
    year = date_comps[0]

    @data = {
    "jsonrpc" => "2.0",
    "id" => 1,
    "method" => "getClientPaymentsHistory",
    "params" => {
        "login" => client_login,
        "clientType" => "Retail",
        "filter" => {
            "dateFrom" => "#{year}-01-01",
            "dateTo" => date_to,
            "moneyFrom" => 0,
            "moneyTo" => 20
    },
            "paging" => {
            "pageNumber" => 0,
            "pageSize" => 10,
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

  end

  def filteredPaymentHistory
    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller1_login]}"
    @password = "#{session[:password]}"
    client_login = session[:client_login]

    date = params[:filteredPaymentHistory]
    

    # addLeadingZero is a helper method to add a leading zero for single digit
    # day or month so that we pass the right date formats to the api method - getClientPaymentsHistory

    from_date_day = date["from_date(3i)"]
    from_date_day = addLeadingZero(from_date_day)
    puts from_date_day

    from_date_month = date["from_date(2i)"]
    from_date_month = addLeadingZero(from_date_month)
    puts from_date_month

    from_date_year = date["from_date(1i)"]
    puts from_date_year

    to_date_day = date["to_date(3i)"]
    puts "hwjhfbejbf"
    puts to_date_day
    to_date_day = addLeadingZero(to_date_day)
    puts "hwjhfbejbf"
    puts to_date_day

    to_date_month = date["to_date(2i)"]
    to_date_month = addLeadingZero(to_date_month)

    to_date_year = date["to_date(1i)"]

    date_from = "#{from_date_year}-#{from_date_month}-#{from_date_day}"
    date_to = "#{to_date_year}-#{to_date_month}-#{to_date_day}"

    @data = {
    "jsonrpc" => "2.0",
    "id" => 1,
    "method" => "getClientPaymentsHistory",
    "params" => {
        "login" => client_login,
        "clientType" => "Retail",
        "filter" => {
            "dateFrom" => date_from,
            "dateTo" => date_to,
            "moneyFrom" => 0,
            "moneyTo" => 20
    },
            "paging" => {
            "pageNumber" => 0,
            "pageSize" => 10,
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
    puts @result
    
  end

  def viewMyClients
    @myClients = DB[:clientsshared].where(:id_reseller => session[:current_reseller1_id])
    respond_to do |format|
      format.html
        format.json { render json: @myClients }
    end
  end

  def viewMyClientsCDR
    @my_cdr = []
    total_cdr = DB[:calls] #cache this so we don't have to query db inside loop
    my_clients = DB[:clientsshared].where(:id_reseller => session[:current_reseller1_id])
    client_ids = getClientsIDs()
    client_ids.each do |id|
      @my_cdr.push(total_cdr.where(:id_client => id))
    end
  end

  def viewActiveCalls
    @active_calls = []
    calls = DB[:currentcalls] #cache this so we don't have to query db inside loop
    client_ids = getClientsIDs()
    puts "IDS"
    puts client_ids
    client_ids.each do |id|
      @active_calls.push(calls.where(:id_client => id))
    end
    puts "CALLLSSSSSS"
    puts @active_calls
  end


  def addPayment

    temp_payment = params[:payment_amount]
    payment_note = params[:payment_note]
    payment = temp_payment.to_f #changed payment to float
    temp_hash = params[:resellers1]
    login = temp_hash["login"] rescue nil


    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller1_login]}"
    @password = "#{session[:password]}"


    @data = { 
      "jsonrpc" => "2.0", 
      "id" => 1, 
      "method" => "doClientPayment", 
      "params" => { 
        "login" => login, 
        "clientType" => "Retail", 
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

    redirect_to "/reseller1s/viewMyClients"    
  end

  def viewMyTariff
    @result = DB[:resellers1].where(:id => session[:current_reseller1_id])
    id_tariff = -1
    @result.each do |c|
      id_tariff = c[:id_tariff]
    end
    @tariff_list = DB[:tariffs].where(:id_tariff => id_tariff)
  end

  def viewClientsTariff
    id_client = params[:id_client]

    puts "IDDDDDD"
    puts id_client    

    @result = DB[:clientsshared].where(:id_client => id_client)
    id_tariff = -1
    @result.each do |c|
      id_tariff = c[:id_tariff]
    end
    @tariff_list = DB[:tariffs].where(:id_tariff => id_tariff)
    #puts @tariff_list
    
  end

  def viewSelected
    @cdr = []
    first_letter = params[:first_letter]
    puts first_letter
    puts Regexp.quote(first_letter).is_a?(String)
    total_cdr = DB[:calls].filter(:caller_id => /^(#{Regexp.quote(first_letter)}|#{Regexp.quote(first_letter.downcase)})/)
    my_clients = DB[:clientsshared].where(:id_reseller => session[:current_reseller1_id])
    client_ids = getClientsIDs()
    client_ids.each do |id|
      @cdr.push(total_cdr.where(:id_client => id))
    end
  end

  def show
    
  end

  def prefix_match (prefix, number)
    i = 1
    temp = ""
    while i < number.size
      temp = number[0..number.size-i]
      if prefix == temp
        return true
      end
      i += 1
    end
    return false
  end

  def getClientsIDs
    my_clients = DB[:clientsshared].where(:id_reseller => session[:current_reseller1_id])
    client_ids = []
    my_clients.each do |c|
      client_ids.push(c[:id_client])
    end
    return client_ids
  end

end
