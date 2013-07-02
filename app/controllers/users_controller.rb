require 'net/http'
require 'json'
require 'rest_client'
class UsersController < ApplicationController  

  def index

  end
  
  def viewMyResellers
    @myResellers = DB[:resellers3]
    respond_to do |format|
      format.html
        format.json { render json: @myResellers }
    end
  end

  def addPayment

    temp_payment = params[:payment_amount]
    payment_note = params[:payment_note]
    payment = temp_payment.to_f #changed payment to float
    temp_hash = params[:resellers3]
    if payment <= 0 
      flash[:error_payment] = "Payment should be great than 0"
    end
    @myResellers = DB[:resellers3]
    @id = DB[:resellers3].where(:login => temp_hash["login"]).first[:id]
    @actual_value = DB[:resellers3].where(:id => @id).first[:callsLimit]
    payment_insertion = DB[:resellerspayments].where(:id_reseller => @id)
    payment_insertion.insert(:money => payment, :id_reseller => @id, :data => Time.now(), :type => 1, :description => "", :actual_value => @actual_value, :resellerlevel => 3)
    
    payment_update = DB[:resellers3].where(:id => @id)
    payment_update.update(:callsLimit => :callsLimit + payment)
    
    flash[:notice_payment] = "Payment successfully added!"
    redirect_to "/users/viewMyResellers"
  end

  def addReseller3
    # go to table tariffreseller and give me the list of id_tariff whose resellerlevel is empty string
    # and then pass it to the view for a drop down selection
    # put the list of the id_tariffs in a variable named @id_tariffs
    
    reseller_tariffs = DB[:tariffreseller]
    all_tariffs = DB[:tariffsnames]
    user_tariff_ids = []
    all_tariffs_array = []
    reseller_tariffs_array = []

    all_tariffs.each do |t|
      all_tariffs_array.push(t[:id_tariff])
    end
    reseller_tariffs.each do |t|
      reseller_tariffs_array.push(t[:id_tariff])
    end

    user_tariff_ids = (all_tariffs_array - reseller_tariffs_array)
    
    @tariff_names = []
    names = []
    user_tariff_ids.each do |id|
     names.push(DB[:tariffsnames].where(:id_tariff => id))
    end
    names.each do |n|
      @tariff_names.push(n.first[:description]) rescue nil
    end
  end

  def addReseller3Submit
    #to begin with, we are passing only limited fields.

    @login = params[:login] #required
    @password = params[:password] #required
    temp_hash = params[:reseller3]
    @id_tariff = DB[:tariffsnames].where(:description => temp_hash["description"]).first[:id_tariff] rescue nil
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

    @tech_prefix = DB[:resellers3].where(:id => 3).first[:tech_prefix]

    begin 
      new_reseller = DB[:resellers3]
      new_reseller.insert(:login => @login, :password => @password, :id_tariff => @id_tariff, :callsLimit => @callsLimit,
                          :clientsLimit => @clientsLimit,  :tech_prefix => @tech_prefix, :identifier => @identifier, :Fullname => @Fullname,
                          :Address => @Address, :City => @City, :ZipCode => @ZipCode, :Country => @Country, :Phone => @Phone, :Email => @Email,
                          :TaxID => "", :type2 => 0, :language => @language, :type => 49601)
    rescue
      flash[:error_adding] ="OOPS! Try again!"
      redirect_to "/users/createTariff"
    end
  end

  def tariffs
    # this is not yet complete....
    reseller_tariffs = DB[:tariffreseller]
    all_tariffs = DB[:tariffsnames]
    user_tariff_ids = []
    all_tariffs_array = []
    reseller_tariffs_array = []

    all_tariffs.each do |t|
      all_tariffs_array.push(t[:id_tariff])
    end
    reseller_tariffs.each do |t|
      reseller_tariffs_array.push(t[:id_tariff])
    end

    user_tariff_ids = (all_tariffs_array - reseller_tariffs_array)
    
    @tariffs = []
    user_tariff_ids.each do |id|
     @tariffs.push(DB[:tariffsnames].where(:id_tariff => id))
    end
  end

  def addRatesToTariff
    @tariff_id = params[:tariff][:id_tariff]
    @tariffs = DB[:tariffs].where(:id_tariff => @tariff_id)
    session[:common_index] = 0
    session[:common_index1] = 20
  end

  def addRatesToTariff1
    session[:common_index] += 20
    session[:common_index1] += 20
    @tariff_id = params[:tariff][:id_tariff]
    @prior =  session[:common_index] + params[:tariff][:id_tariffs_key].to_i
    @latter = session[:common_index1] + params[:tariff][:id_tariffs_key].to_i
    @temp_id = params[:tariff][:id_tariffs_key].to_i + 20
    @tariffs = DB[:tariffs].where(:id_tariff => @tariff_id, :id_tariffs_key => @prior.to_i..@latter.to_i)
    
  end

  def addRatesToTariffSubmit
    @tariff = DB[:tariffs].where(:id_tariffs_key => params[:t_id])
    @tariff.update(:voice_rate => params[:voice_rate], :description => params[:description], :rate_addition => params[:rate_addition], :rate_multiplier => params[:rate_multiplier], :grace_period => params[:grace_period])
  end

  def createTariff
    
  end

  def createTariffSubmit
    description = params[:description].capitalize
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

      flash[:notice_added] = "Tariff successfully created!"
      redirect_to "/users/tariffs"
    rescue
      flash[:error_adding] = "Tariff could not created! Try again! or contact the administrator."
      redirect_to "/users/createTariff"
    end

      
  end

  def show
  end

end
