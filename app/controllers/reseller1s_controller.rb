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
      @calls.push(DB[:calls].where(:id_client => client[:id_client]))
    end
    
    @calls.each do |calls|
      calls.each do |call|
       @total_revenue += (call[:cost]) 
       @total_cost += (call[:costR1])
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
    @result = DB[:resellers1].where(:id => session[:current_reseller1_id]) rescue nil
    id_tariff = @result.first[:id_tariff] rescue nil
    @tariff_list = DB[:tariffs].where(:id_tariff => id_tariff) rescue nil

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

  def agentsTariffs
    @my_agents_tariffs = getAgentTariffs()
    if not @my_agents_tariffs[0].first
      flash[:error] = "Sorry no tariffs found!"
      redirect_to '/reseller2s'
    end
  end

  def viewTariff
    @tariff_id = params[:tariff][:id_tariff]
    @name = DB[:tariffsnames].where(:id_tariff => @tariff_id).first[:description]
    @tariffs = DB[:tariffs].where(:id_tariff => @tariff_id)
    session[:tariff_id] = @tariff_id
    session[:name] = @name
    session[:common_index] = 0
    session[:common_index1] = 20
  end

  def viewTariff1
    session[:common_index] += 20
    session[:common_index1] += 20
    @tariff_id = params[:tariff][:id_tariff]
    @name = session[:name]
    @prior =  session[:common_index] + params[:tariff][:id_tariffs_key].to_i
    @latter = session[:common_index1] + params[:tariff][:id_tariffs_key].to_i
    @temp_id = params[:tariff][:id_tariffs_key].to_i + 20
    @tariffs = DB[:tariffs].where(:id_tariff => @tariff_id, :id_tariffs_key => @prior.to_i..@latter.to_i)
  end

  def editTariff
    session[:id_tariffs_key] = params[:t_id]
    @tariffs = DB[:tariffs].where(:id_tariffs_key => params[:t_id])
  end

  def editTariffSubmit
    description = params[:description].capitalize
    minimal_time = params[:minimal_time].to_i
    resolution = params[:resolution].to_i
    surcharge_time = params[:surcharge_time].to_i 
    surcharge_amount = params[:surcharge_amount].to_f 
    prefix = params[:prefix].to_i
    voice_rate = params[:voice_rate].to_f
    rate_multiplier = params[:rate_multiplier].to_f
    rate_addition = params[:rate_addition].to_f 
    from_day = params[:from_day].to_i
    to_day = params[:to_day].to_i
    from_hour = params[:from_hour].to_i
    to_hour = params[:to_hour].to_i
    grace_period = params[:grace_period].to_i
    free_seconds = params[:free_seconds].to_s
    @tariffs = DB[:tariffs].where(:id_tariffs_key => session[:id_tariffs_key])
    begin
      @tariffs.update(:description => description, :minimal_time => minimal_time, :resolution => resolution,
        :surcharge_time => surcharge_time, :surcharge_amount => surcharge_amount, :prefix => prefix, :voice_rate => voice_rate,
        :rate_multiplier => rate_multiplier, :rate_addition => rate_addition, :from_day => from_day, :to_day => to_day,
        :from_hour => from_hour, :to_hour => to_hour, :grace_period => grace_period, :free_seconds => free_seconds)
      flash[:notice] = "Tariff successfully updated"
      redirect_to "/reseller1s/viewMyTariff"
    rescue
      flash[:error] = "Tariff could not be updated! Try again! or contact the administrator."
      redirect_to "/reseller1s/editTariff"
    end
  end

  def addNewTariff
    #just getting a sample tariff to prefill the form
    agent_tariff_id = getAgentTariffs()
    @tariff_id = agent_tariff_id[0].first[:id_tariff]
    @tariffs = DB[:tariffs].where(:id_tariff => @tariff_id)     
  end

  def addNewTariffSubmit
    description = params[:description].capitalize
    minimal_time = params[:minimal_time].to_i
    resolution = params[:resolution].to_i
    surcharge_time = params[:surcharge_time].to_i 
    surcharge_amount = params[:surcharge_amount].to_f 
    prefix = params[:prefix].to_i
    voice_rate = params[:voice_rate].to_f
    rate_multiplier = params[:rate_multiplier].to_f
    rate_addition = params[:rate_addition].to_f 
    from_day = params[:from_day].to_i
    to_day = params[:to_day].to_i
    from_hour = params[:from_hour].to_i
    to_hour = params[:to_hour].to_i
    grace_period = params[:grace_period].to_i
    free_seconds = params[:free_seconds].to_s
    begin
      DB[:tariffs].insert(:id_tariff => session[:tariff_id], :description => description, :minimal_time => minimal_time, :resolution => resolution,
        :surcharge_time => surcharge_time, :surcharge_amount => surcharge_amount, :prefix => prefix, :voice_rate => voice_rate,
        :rate_multiplier => rate_multiplier, :rate_addition => rate_addition, :from_day => from_day, :to_day => to_day,
        :from_hour => from_hour, :to_hour => to_hour, :grace_period => grace_period, :free_seconds => free_seconds)
      flash[:notice] = "Tariff successfully added"
      redirect_to "/reseller1s/viewMyTariff"
    rescue
      flash[:error] = "Tariff could not be added! Try again! or contact the administrator."
      redirect_to "/reseller1s/addNewTariff"
    end
  end

  def createTariff
  end

  def createTariffFromBase
    @result = DB[:resellers1].where(:id => session[:current_reseller1_id])
    id_tariff = @result.first[:id_tariff]
    @tariff_name = DB[:tariffsnames].where(:id_tariff => id_tariff).first[:description]
  end
  
  def createTariffFromBaseSubmit
    @result = DB[:resellers1].where(:id => session[:current_reseller1_id])
    id_tariff = @result.first[:id_tariff]
    @tariff = DB[:tariffsnames].where(:id_tariff => id_tariff).first
    rate_multiplier = params[:rate_multiplier].to_f
    identifier = params[:identifier]
    description = identifier + ":" + params[:description].capitalize
    begin
      DB[:tariffsnames].insert(:description => description, :minimal_time => @tariff[:minimal_time], :resolution => @tariff[:resolution],  
        :rate_multiplier => @tariff[:rate_multiplier], :rate_addition => @tariff[:rate_addition], :surcharge_time => @tariff[:surcharge_time],
        :surcharge_amount => @tariff[:surcharge_amount], :type => @tariff[:type], :rate_multiplier => rate_multiplier, :rate_addition => @tariff[:rate_addition],
        :id_currency => @tariff[:id_currency], :time_to_start => @tariff[:time_to_start], :base_tariff_id => @tariff[:base_tariff_id],
        :cost_threshold_resolution => @tariff[:cost_threshold_resolution], :cost_threshold => @tariff[:cost_threshold])

      @id_tariff = DB[:tariffsnames].where(:description => description).first[:id_tariff]

      DB[:tariffreseller].insert(:id_tariff => @id_tariff, :id_reseller => session[:current_reseller1_id], :resellerlevel => 1)

      @tariff_list = DB[:tariffs].where(:id_tariff => @id_tariff)
      #@tariff_list.each_slice(1000).to_a.each do |a|
      #  temp_array = []
     #   a.each do |h|
          #temp_array.push"(@id_tariff, #{h[:description]}, h[:minimal_time], h[:resolution], h[:surcharge_time], h[:surcharge_amount], #{[h[:prefix]}, h[:voice_rate],
          #h[:rate_multiplier], h[:rate_addition], h[:from_day], h[:to_day],h[:from_hour], h[:to_hour], h[:grace_period], #{h[:free_seconds]})"
      #   temp_array1 = h.values
      #   temp_array1[1] = id_tariff
      #   temp_array1[2] = "'#{temp_array1[2]}'"
      #   temp_array1[3] = "'#{temp_array1[3]}'"
      #   temp_array1[16] = "'#{temp_array1[16]}'"
      #   temp_array.push temp_array1.join(', ')
      #  end
        #(0...temp_array.size).each do |i|
        #   if i.class.eql?(String)
         #   temp_array[i] = "'#{temp_array[i]}'"
         # end
       # end
      #  @joined = temp_array.join(",")
      #  puts "HJKGFHJS"
      #  puts @joined
        #DB["INSERT INTO tariffs (id_tariff, description, minimal_time, resolution, surcharge_time, surcharge_amount, prefix, voice_rate,
        #  rate_multiplier, rate_addition, from_day, to_day, from_hour, to_hour, grace_period, free_seconds), VALUES (#{@joined})"].insert
      #end
     
      @tariff_list.each do |t|
        DB[:tariffs].insert(:id_tariff => @id_tariff, :description => t[:description], :minimal_time => t[:minimal_time], :resolution => t[:resolution],
          :surcharge_time => t[:surcharge_time], :surcharge_amount => t[:surcharge_amount], :prefix => t[:prefix], :voice_rate => t[:voice_rate],
          :rate_multiplier => rate_multiplier, :rate_addition => t[:rate_addition], :from_day => t[:from_day], :to_day => t[:to_day],
          :from_hour => t[:from_hour], :to_hour => t[:to_hour], :grace_period => t[:grace_period], :free_seconds => t[:free_seconds])
      end
      flash[:notice_added] = "Tariff successfully created!"
      redirect_to "/reseller1s/agentsTariffs"
    rescue Exception => e
      flash[:error_adding] = "#{e.message}"
      redirect_to "/reseller1s/createTariffFromBase"
    end
  end

  def createTariffSubmit
    identifier = DB[:resellers1].where(:id => session[:current_reseller1_id]).first[:identifier]
    description = identifier + ":" + params[:description].capitalize
    minimal_time = params[:minimal_time].to_i
    resolution = params[:resolution].to_i
    surcharge_time = params[:surcharge_time].to_i 
    surcharge_amount = params[:surcharge_amount].to_f 
    type = params[:type].to_i
    rate_multiplier = params[:rate_multiplier].to_f
    rate_addition = params[:rate_addition].to_f 
    id_currency = params[:id_currency].to_i
    time_to_start = Time.new(*params[:time_to_start].to_hash.values).strftime("%Y-%m-%d %H:%M:%S")
    base_tariff_id = params[:base_tariff_id].to_i
    cost_threshold_resolution = params[:cost_threshold_resolution].to_f  
    cost_threshold = params[:cost_threshold].to_f    

    begin
      DB[:tariffsnames].insert(:description => description, :minimal_time => minimal_time, :resolution => resolution,  
        :rate_multiplier => rate_multiplier, :rate_addition => rate_addition, :surcharge_time => surcharge_time,
        :surcharge_amount => surcharge_amount, :type => type, :rate_multiplier => rate_multiplier, :rate_addition => rate_addition,
        :id_currency => id_currency, :time_to_start => time_to_start, :base_tariff_id => base_tariff_id, 
        :cost_threshold_resolution => cost_threshold_resolution, :cost_threshold => cost_threshold)

      @id_tariff = DB[:tariffsnames].where(:description => description).first[:id_tariff]

      DB[:tariffreseller].insert(:id_tariff => @id_tariff, :id_reseller => session[:current_reseller1_id], :resellerlevel => 1)

      flash[:notice_added] = "Tariff successfully created!"
      redirect_to "/reseller1s/agentsTariffs"
    rescue
      flash[:error_adding] = "Tariff could not created! Try again! or contact the administrator."
      redirect_to "/reseller1s/createTariff"
    end    
  end

  def show
  end
  
  def getAgentTariffs
    my_agents_tariffs = []
    reseller_tariffs = DB[:tariffreseller].where(:id_reseller => session[:current_reseller1_id])
    id_tariff_array = []

    reseller_tariffs.each do |rt|
      id_tariff_array.push(rt[:id_tariff])
    end

    id_tariff_array.each do |id|
     my_agents_tariffs.push(DB[:tariffsnames].where(:id_tariff => id))
    end
    return my_agents_tariffs
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