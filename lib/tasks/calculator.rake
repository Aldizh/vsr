DB = Sequel.connect("mysql2://resell:ciaouser@209.200.231.9:3306/voipswitch")
desc "calculate profit"
task :calculate_profit => :environment do
	@total_cost = 0
    @total_revenue = 0
    @client_calls = []
    @my_clients = DB[:clientsshared].where(:id_reseller => ENV["CURRENT_RESELLER3_ID"])
    @my_clients.each do |client|
      @client_calls.push(DB[:calls].where(:id_client => client[:id_client]))
    end
    @client_calls.each do |calls|
      calls.each do |call|
        @total_revenue += (call[:cost]) 
        @total_cost += (call[:costR3])
      end
    end
    
    @reseller_calls = []
    @my_resellers2 = DB[:resellers2].where(:idReseller => ENV["CURRENT_RESELLER3_ID"])
    @my_resellers2.each do |reseller2|
      @my_resellers1 = DB[:resellers1].where(:idReseller => reseller2[:id])
      @my_resellers1.each do |reseller|
        @reseller_calls.push(DB[:calls].where(:id_reseller => reseller[:id]))
      end
    end

    @reseller_calls.each do |calls|
      calls.each do |call|
        @total_revenue += (call[:costR2]) 
        @total_cost += (call[:costR3])
      end
    end
end