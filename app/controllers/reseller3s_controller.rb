require 'net/http'
require 'json'
require 'rest_client'
class Reseller3sController < ApplicationController  

  def index
    
    @total_cost = 0
    @total_revenue = 0
    @client_calls = []
    @my_clients = DB[:clientsshared].where(:id_reseller => session[:current_reseller3_id])
    @my_clients.each do |client|
      @client_calls.push(DB[:calls].where(:id_client => client[:id_client]))
    end
    @client_calls.each do |calls|
      calls.each do |call|
        @total_revenue += (call[:cost]) 
        @total_cost += (call[:costR3])
      end
    end
    
    @reseller2_calls = []
    @my_resellers2 = DB[:resellers2].where(:idReseller => session[:current_reseller3_id])
    @my_resellers2.each do |reseller|
      @reseller2_calls.push(DB[:calls].where(:id_reseller => reseller[:id]))
    end

    @reseller2_calls.each do |calls|
      calls.each do |call|
        @total_revenue += (call[:costR2]) 
        @total_cost += (call[:costR3])
      end
    end


    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller3_login]}"
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
    @login = "#{session[:current_reseller3_login]}"
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
        "clientType" => "Reseller",
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
    @login = "#{session[:current_reseller3_login]}"
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
        "clientType" => "Reseller",
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

  def viewMyResellers
    @myResellers = DB[:resellers2].where(:idReseller => session[:current_reseller3_id])
    res = params[:resellers3]
    puts res
    respond_to do |format|
      format.html
        format.json { render json: @myResellers }
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

  def viewMyResellersCDR
    @my_cdr = []
    @client_CDR = []
    total_cdr = DB[:calls] #cache this so we don't have to query db inside loop
    reseller2s_ids = getClientsIDs()
    reseller1s_ids = []

    reseller2s_ids.each do |id|
     @temp = DB[:Resellers1].where(:idReseller => id)
     @temp.each do |e|
      reseller1s_ids.push(e[:id])
     end
    end
    reseller1s_ids.each do |id|
      @my_cdr.push(total_cdr.where(:id_reseller => id))
    end
  end

  def addPayment

    temp_payment = params[:payment_amount]
    payment_note = params[:payment_note]
    payment = temp_payment.to_f #changed payment to float
    temp_hash = params[:resellers3]
    login = temp_hash["login"] rescue nil
    
    if payment <= 0 
      flash[:error_payment] = "Payment should be great than 0"
    end

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

    @result = API_request(@login, @password, @url, @data)


    if @result["error"] 
      flash[:error_payment] = "Payment did not go through. Please try again!"
    else 
      flash[:notice_payment] = "Payment added successfully!"
    end

    redirect_to "/reseller3s/viewMyResellers"

  end

  def addReseller2
    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller3_login]}"
    @password = "#{session[:password]}"

    @data = {
      "jsonrpc" => "2.0",
      "id" => 1,
      "method" => "arrayOfTariffs",
      "params" => {}
      }.to_json

      @result = API_request(@login, @password, @url, @data)
    
  end

  def addReseller2Submit

    @login = params[:login] #required
    @password = params[:password] #required
    temp_hash = params[:reseller2]
    @id_tariff = DB[:tariffsnames].where(:description => temp_hash["description"]).first[:id_tariff] rescue nil
    if @id_tariff == nil     
      @id_tariff = DB[:resellers3].where(:id => session[:current_reseller3_id]).first[:id_tariff]
    end
    @callsLimit = params[:callsLimit] #required
    @clientsLimit = params[:clientsLimit] #required
    @identifier =   params[:identifier] #required
    @Fullname = params[:Fullname] || ""#required
    @Address = params[:Address] || "" #required
    @City = params[:City] || ""#required
    @ZipCode = params[:ZipCode] || "" #required
    @Country = params[:Country] || "" #required
    @Phone = params[:Phone] || ""#required
    @Email = params[:Email] || ""#required
    @TaxID = params[:TaxID] #required 
    @language = params[:language] || ""#required
    @tech_prefix = DB[:resellers3].where(:id => session[:current_reseller3_id]).first[:tech_prefix]

    begin
      new_reseller = DB[:resellers2]
      new_reseller.insert(:login => @login, :password => @password, :type => @tyoe, :id_tariff => @id_tariff, :callsLimit => @callsLimit,
                        :clientsLimit => @clientsLimit,  :tech_prefix => @tech_prefix, :identifier => @identifier, :Fullname => @Fullname,
                        :Address => @Address, :City => @City, :ZipCode => @ZipCode, :Country => @Country, :Phone => @Phone, :Email => @Email,
                        :TaxID => "", :type2 => 0, :language => @language, :type => 49601, :idReseller => session[:current_reseller3_id])
      
      flash[:notice] ="HURRAY! ADDED successfully!"
      redirect_to "/reseller3s/viewMyResellers"
    rescue
      flash[:error] ="OOPS! Try again!"
      redirect_to "/reseller3s/addReseller2"
    end    
  end

  def viewMyTariff
    @result = DB[:resellers3].where(:id => session[:current_reseller3_id])
    id_tariff = @result.first[:id_tariff]
    @tariff_list = DB[:tariffs].where(:id_tariff => id_tariff)
  end

  def viewResellers2Tariff
    id_agent = params[:id_agent] 

    @result = DB[:resellers2].where(:id => id_agent)
    id_tariff = @result.first[:id_tariff]
    @tariff_list = DB[:tariffs].where(:id_tariff => id_tariff)
  end

  def viewSelected
    @cdr = []
    first_letter = params[:first_letter]
    total_cdr = DB[:calls].filter(:caller_id => /^(#{Regexp.quote(first_letter)}|#{Regexp.quote(first_letter.downcase)})/)
    reseller2s_ids = getClientsIDs()
    reseller1s_ids = []

    reseller2s_ids.each do |id|
     @temp = DB[:Resellers1].where(:idReseller => id)
     @temp.each do |e|
      reseller1s_ids.push(e[:id])
     end
    end
    reseller1s_ids.each do |id|
      @cdr.push(total_cdr.where(:id_reseller => id))
    end
  end

  def viewSelectedTariff
    @tariff_list = []
    first_letter = params[:first_letter]
    total_tariff = DB[:tariffs].filter(:description => /^(#{Regexp.quote(first_letter)}|#{Regexp.quote(first_letter.downcase)})/)
    clients = DB[:resellers2].where(:idReseller => session[:current_reseller3_id])
    clients.each do |client|
      @tariff_list.push(total_tariff.where(:id_tariff => client[:id_tariff]))
    end
  end

  def agentsTariffs
    @my_agents_tariffs = getAgentTariffs()
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
      redirect_to "/reseller3s/viewMyTariff"
    rescue
      flash[:error] = "Tariff could not be updated! Try again! or contact the administrator."
      redirect_to "/reseller3s/editTariff"
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
      redirect_to "/reseller3s/viewMyTariff"
    rescue
      flash[:error] = "Tariff could not be added! Try again! or contact the administrator."
      redirect_to "/reseller3s/addNewTariff"
    end
  end

  def createTariff
    
  end

  def createTariffSubmit

    identifier = DB[:resellers3].where(:id => session[:current_reseller3_id]).first[:identifier]
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

      DB[:tariffreseller].insert(:id_tariff => @id_tariff, :id_reseller => session[:current_reseller3_id], :resellerlevel => 3)

      flash[:notice_added] = "Tariff successfully created!"
      redirect_to "/reseller3s/agentsTariffs"
    rescue
      flash[:error_adding] = "Tariff could not created! Try again! or contact the administrator."
      redirect_to "/reseller3s/createTariff"
    end    
  end

  def show
  end

  def getClientsIDs
    reseller2s_ids = []
    my_direct_clients = DB[:Resellers2].where(:idReseller => session[:current_reseller3_id])
    my_direct_clients.each do |c|
      reseller2s_ids.push(c[:id])
    end
    return reseller2s_ids
  end

  def getAgentTariffs
    my_agents_tariffs = []
    reseller_tariffs = DB[:tariffreseller].where(:id_reseller => session[:current_reseller3_id])
    id_tariff_array = []

    reseller_tariffs.each do |rt|
      id_tariff_array.push(rt[:id_tariff])
    end

    id_tariff_array.each do |id|
     my_agents_tariffs.push(DB[:tariffsnames].where(:id_tariff => id))
    end
    return my_agents_tariffs
  end
end
