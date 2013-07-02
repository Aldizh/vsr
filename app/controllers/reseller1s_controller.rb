require 'net/http'
require 'json'
require 'rest_client'
class Reseller1sController < ApplicationController  

  def index
    @total_cost = 0
    @total_revenue = 0
    @calls = []
    @my_clients = DB[:clientsshared].where(:id_reseller => session[:current_reseller1_id])
    @my_clients.each do |client|
      @calls.push(DB[:calls_costs].where(:id_client => client[:id_client]))
    end
    @calls.each do |call|
      if call.first
        duration = call.first[:duration]

        @client_tariffs = DB[:tariffs].where(:id_tariff => call.first[:id_tariff], :prefix => call.first[:tariff_prefix])
        @client_tariffs.each do |tariff|
          if (tariff[:minimal_value] == 6 and tariff[:resolution] == 6) 
            @total_revenue += (duration*tariff[:voice_rate]/36)
            #@total_revenue += (duration*cheapestRoute(tariff[:prefix])/36)
          else
            @total_revenue += (duration*tariff[:voice_rate])
            #@total_revenue += (duration*cheapestRoute(tariff[:prefix])/60)
          end
        end
         
        @current = DB[:resellers1].where(:id => session[:current_reseller1_id])
        @parent = DB[:resellers2].where(:id => @current.first[:idReseller])
        @reseller_tariffs = DB[:tariffs].where(:id_tariff => @current.first[:id_tariff], :prefix => call.first[:tariff_prefix])
        @reseller_tariffs.each do |tariff|
          if (tariff[:minimal_value] == 6 and tariff[:resolution] == 6) 
            @total_cost += (duration*tariff[:voice_rate]/36)
            #@total_cost += (duration*cheapestRoute(tariff[:prefix])/36)
          else
            @total_cost += (duration*tariff[:voice_rate])
            #@total_cost += (duration*cheapestRoute(tariff[:prefix])/60)
          end
        end
      end

    end

    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller1_login]}"
    @password = "#{session[:password]}"

    @data = {
      "jsonrpc" => "2.0",
      "id" => 1,
      "method" => "getMyDetails",
      "params" => {}
    }.to_json

    @result = API_request(@login, @password, @url, @data)

  end


  def payment_history

    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller1_login]}"
    @password = "#{session[:password]}"
    client_login = params[:login]
    client_id = params[:id]
    session[:client_login] = client_login
    
    today = Time.new
    date_to = (today.to_s).split(" ")[0]
    year = today.year.to_s

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

    @result = API_request(@login, @password, @url, @data)

  end

  def filteredPaymentHistory
    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller1_login]}"
    @password = "#{session[:password]}"
    client_login = session[:client_login]

    date = params[:filteredPaymentHistory]
    
    date_from = Time.new(date["from_date(1i)"], date["from_date(2i)"], date["from_date(3i)"]).strftime("%Y-%m-%d")
    date_to = Time.new(date["to_date(1i)"], date["to_date(2i)"], date["to_date(3i)"]).strftime("%Y-%m-%d")

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


    @result = API_request(@login, @password, @url, @data)
    
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
    client_ids.each do |id|
      @active_calls.push(calls.where(:id_client => id))
    end
  end


  def addPayment

    temp_payment = params[:payment_amount]
    payment_note = params[:payment_note]
    payment = temp_payment.to_f #changed payment to float
    temp_hash = params[:resellers1]
    login = temp_hash["login"] rescue nil

    if payment <= 0 
      flash[:error_payment] = "Payment should be great than 0"
    end
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

    @result = API_request(@login, @password, @url, @data)

    if @result["error"] 
      flash[:error_payment] = "Payment did not go through. Please try again!"
    else 
      flash[:notice_payment] = "Payment added successfully!"
    end

    redirect_to "/reseller1s/viewMyClients"    
  end

  def addClient

    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller1_login]}"
    @password = "#{session[:password]}"

    ####### PREFIX SD
    @data_tariff = {
      "jsonrpc" => "2.0",
      "id" => 1,
      "method" => "arrayOfTariffs",
      "params" => {}
      }.to_json

    @result_tariff = API_request(@login, @password, @url, @data_tariff)
    
  end

  # in addClientSubmit, you will come across these similar looking api method - arrayOfPrefixesXX.
  # These are crucial for clients in retreiving the Prefixs that their R1 uses.
  
  def addClientSubmit
    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller1_login]}"
    @password = "#{session[:password]}"

    @client_login = params[:login]
    @client_password = params[:password]
    @client_pin = params[:pin]
    @client_calls_limit = params[:calls_limit]
    temp_hash = params[:client]
    @tariff = temp_hash["tariff"] rescue nil

    session[:client_login] = @client_login
    session[:client_pin] = @client_pin
    session[:client_calls_limit] = @client_calls_limit

    if isValidLogin(@client_login)
      if isValidPassword(@client_password)

        ####### PREFIX SD
        @data_sd = {
          "jsonrpc" => "2.0",
          "id" => 1,
          "method" => "arrayOfPrefixesSD",
          "params" => {}
          }.to_json

        @response_sd = RestClient::Request.new(
          :method => :post,
          :payload => @data_sd,
          :url => @url,
          :user => @login,
          :password => @password,
          :headers => { :accept => :json, :content_type => :json}).execute

        @result_sd = ActiveSupport::JSON.decode(@response_sd)

        ###### PREFIX ST

        @data_st = {
          "jsonrpc" => "2.0",
          "id" => 1,
          "method" => "arrayOfPrefixesST",
          "params" => {}
          }.to_json

        @response_st = RestClient::Request.new(
          :method => :post,
          :payload => @data_st,
          :url => @url,
          :user => @login,
          :password => @password,
          :headers => { :accept => :json, :content_type => :json}).execute

        @result_st = ActiveSupport::JSON.decode(@response_st)

        ####### PREFIX DP

        @data_dp = {
          "jsonrpc" => "2.0",
          "id" => 1,
          "method" => "arrayOfPrefixesDP",
          "params" => {}
          }.to_json

        @response_dp = RestClient::Request.new(
          :method => :post,
          :payload => @data_dp,
          :url => @url,
          :user => @login,
          :password => @password,
          :headers => { :accept => :json, :content_type => :json}).execute

        @result_dp = ActiveSupport::JSON.decode(@response_dp)

        ####### PREFIX TP

        @data_tp = {
          "jsonrpc" => "2.0",
          "id" => 1,
          "method" => "arrayOfPrefixesTP",
          "params" => {}
          }.to_json

        @result_tp = API_request(@login, @password, @url, @data_tp)

        ###### ADD RETAIL

        @data = {
          "jsonrpc" => "2.0",
          "id" => 1,
          "method" => "addRetail",
          "params" => {
            "client" => {
              "login" => "#{@client_login}",
              "password" => "#{@client_password}",
              "pin" => "#{@client_pin}" ,
              "active" => true,
              "tariffName" => @tariff,
              "callLimit" => @client_calls_limit,
              "recognizeByANI" => false,
              "generateRingBack" => false,
              "connectImmediately" => false,
              "waitForBlindTransferResult" => false,
              "recordCalls" => false,
              "tariffToANI" => false,
              "tariffToDNIs" => false,
              "useInterIntraTariffs" => false,
              "getRateFromDesctination" => false,
              "prefixes" => {
                "SD" => @result_sd["result"][0],
                "ST" => @result_st["result"][0],
                "DP" => @result_dp["result"][0],
                "TP" => @result_tp["result"][0],
                },
              }
            }
          }.to_json

        @result = API_request(@login, @password, @url, @data) 

        if @result["error"] 
          flash[:error_adding] = "Oops! Try again!"
        else 
          flash[:notice_added] = "Hurray! Added!"
        end
      else
      flash[:error_adding] = "Password must be atleast 4 characters."
      redirect_to "/reseller1s/addClient"
      end
    else
      flash[:error_adding] = "Login must be atleast 4 characters."
      redirect_to "/reseller1s/addClient"
    end

  end

  # testMethod2 doesn't is simply to test if getRetails (returning list of clients for R1) works or not
  # and YAY! it works! We should use this APU method instead of reading database for R1. We can do the same for R2 and R3.
  # But for end users and users, we have to live with the DB Read. 

  def testMethod2
    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller1_login]}"
    @password = "#{session[:password]}"

    puts @login
    puts @password

    @data = {
      "jsonrpc" => "2.0",
      "id" => 1,
      "method" => "getRetails",
      "params" => {
        "filter" => {
          "login" => "",
          "password" => "",
          "tariffName" => "",
          "remainingFundsFrom" => 0.0,
          "remainingFundsTo" => 0.0,
          "active" => true,
          "ani" => "",
      },
          "paging" => {
          "pageNumber" => 0,
          "pageSize" => 10,
          "descending" => false,
          },
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


  def viewMyTariff
    @result = DB[:resellers1].where(:id => session[:current_reseller1_id])
    id_tariff = @result.first[:id_tariff]
    @tariff_list = DB[:tariffs].where(:id_tariff => id_tariff)

  end

  def viewClientsTariff
    @result = DB[:clientsshared].where(:id_client => params[:id_client])
    id_tariff = @result.first[:id_tariff]
    @tariff_list = DB[:tariffs].where(:id_tariff => id_tariff)
  end

  def viewSelected
    @cdr = []
    first_letter = params[:first_letter]
    total_cdr = DB[:calls].filter(:caller_id => /^(#{Regexp.quote(first_letter)}|#{Regexp.quote(first_letter.downcase)})/)
    client_ids = getClientsIDs()
    client_ids.each do |id|
      @cdr.push(total_cdr.where(:id_client => id))
    end
  end

  def viewSelectedTariff
    @tariff_list = []
    first_letter = params[:first_letter]
    total_tariff = DB[:tariffs].filter(:description => /^(#{Regexp.quote(first_letter)}|#{Regexp.quote(first_letter.downcase)})/)
    clients = DB[:clientsshared].where(:id_reseller => session[:current_reseller1_id])
    clients.each do |client|
      @tariff_list.push(total_tariff.where(:id_tariff => client[:id_tariff]))
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

  #use this method to calculate the cheapest cost call
  

  def isValidLogin(login)
    if login.length < 4
      return false
    else
      return true
    end
  end

  def isValidPassword(password)
    if password.length < 4
      return false
    else
      return true
    end
  end

end