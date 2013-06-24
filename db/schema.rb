# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "accounts", :primary_key => "id_account", :force => true do |t|
    t.integer "id_client",                                                     :null => false
    t.integer "client_type",                                                   :null => false
    t.decimal "account_state", :precision => 12, :scale => 4, :default => 0.0, :null => false
    t.integer "account_type",                                                  :null => false
    t.integer "account_data",                                                  :null => false
  end

  add_index "accounts", ["account_type"], :name => "IX_AccountsType"
  add_index "accounts", ["client_type"], :name => "IX_AccountsClientType"
  add_index "accounts", ["id_client"], :name => "IX_AccountsIdClient"

  create_table "accounts_types", :force => true do |t|
    t.string "name", :limit => 50, :null => false
  end

  create_table "accountstate", :primary_key => "IDPosition", :force => true do |t|
    t.integer "Type"
    t.integer "IDLots"
    t.decimal "Amount",                     :precision => 18, :scale => 2,                     :null => false
    t.binary  "useHTML",       :limit => 1,                                :default => "b'0'", :null => false
    t.text    "msgBody"
    t.text    "msgTitle"
    t.string  "HTMLPath"
    t.integer "notify_count",                                              :default => -1,     :null => false
    t.integer "id_client",                                                 :default => -1,     :null => false
    t.integer "notify_period",                                             :default => -1,     :null => false
    t.string  "sender_name",                                               :default => "",     :null => false
    t.string  "reply_to",                                                  :default => "",     :null => false
    t.string  "thresholds",                                                :default => "",     :null => false
  end

  create_table "accountstatereseller", :primary_key => "IDPosition", :force => true do |t|
    t.integer "ResellerLevel"
    t.decimal "Amount",                     :precision => 18, :scale => 2,                     :null => false
    t.binary  "useHTML",       :limit => 1,                                :default => "b'0'", :null => false
    t.text    "msgBody"
    t.text    "msgTitle"
    t.string  "HTMLPath"
    t.integer "notify_count",                                              :default => -1,     :null => false
    t.integer "id_reseller",                                               :default => -1,     :null => false
    t.integer "notify_period",                                             :default => -1,     :null => false
    t.string  "sender_name",                                               :default => "",     :null => false
    t.string  "reply_to",                                                  :default => "",     :null => false
    t.string  "thresholds",                                                :default => "",     :null => false
  end

  create_table "activepc2phone", :primary_key => "id_active_pc2phone", :force => true do |t|
    t.integer  "id_client"
    t.string   "login",      :limit => 20
    t.datetime "login_time"
    t.string   "ip_number",  :limit => 33
  end

  create_table "address_book", :force => true do |t|
    t.integer "client_type",                                               :null => false
    t.integer "id_client",                                                 :null => false
    t.string  "firstname",            :limit => 50
    t.string  "lastname",             :limit => 50
    t.integer "id_group"
    t.string  "timezone",             :limit => 100
    t.string  "street",               :limit => 50
    t.string  "postal",               :limit => 50
    t.string  "state",                :limit => 50
    t.string  "country",              :limit => 50
    t.string  "city",                 :limit => 50
    t.string  "email",                :limit => 50
    t.string  "homepage",             :limit => 50
    t.text    "phones",               :limit => 2147483647
    t.text    "notes",                :limit => 2147483647
    t.text    "instantmsg",           :limit => 2147483647
    t.text    "custom",               :limit => 2147483647
    t.integer "change_time",                                               :null => false
    t.integer "database_change_time",                                      :null => false
    t.integer "deleted",                                    :default => 0, :null => false
  end

  create_table "address_book_groups", :force => true do |t|
    t.integer "client_type",                                       :null => false
    t.integer "id_client",                                         :null => false
    t.string  "name",                 :limit => 50,                :null => false
    t.integer "change_time",                                       :null => false
    t.integer "database_change_time",                              :null => false
    t.integer "deleted",                            :default => 0, :null => false
  end

  create_table "addressbook", :primary_key => "id_address_book", :force => true do |t|
    t.integer "id_client",                                      :null => false
    t.string  "telephone_number", :limit => 50
    t.string  "nickname",         :limit => 20
    t.integer "type",                           :default => 1,  :null => false
    t.string  "speeddial",        :limit => 20, :default => ""
  end

  create_table "anitariff", :force => true do |t|
    t.string  "prefix",    :limit => 50, :null => false
    t.integer "id_tariff",               :null => false
  end

  create_table "assigned_did", :force => true do |t|
    t.integer "id_reseller",                  :null => false
    t.integer "reseller_level",               :null => false
    t.integer "id_lot",                       :null => false
    t.string  "did_number",     :limit => 40, :null => false
    t.integer "status"
  end

  create_table "callback_routes", :force => true do |t|
    t.string  "description",                       :limit => 50, :default => "", :null => false
    t.string  "destination_leg_number",            :limit => 50, :default => "", :null => false
    t.integer "default_client_type",                                             :null => false
    t.integer "default_id_client",                                               :null => false
    t.integer "codecs",                                          :default => 0,  :null => false
    t.integer "triggering_delay",                                :default => 0,  :null => false
    t.integer "callback_type",                                   :default => 0,  :null => false
    t.string  "source_leg_trigger_wave_file",                    :default => "", :null => false
    t.string  "source_leg_connect_wave_file",                    :default => "", :null => false
    t.string  "authorized_client_dest_leg_number", :limit => 50, :default => "", :null => false
    t.integer "primary_codec",                                   :default => 0,  :null => false
    t.integer "fax_primary_codec",                               :default => 0,  :null => false
    t.integer "video_primary_codec",                             :default => 0,  :null => false
  end

  create_table "callback_tasks", :force => true do |t|
    t.integer  "task_status",                                :default => 0,   :null => false
    t.integer  "task_type",                                  :default => 0,   :null => false
    t.datetime "execution_time",                                              :null => false
    t.integer  "delta_time",                                 :default => 900, :null => false
    t.integer  "max_number_of_tries",                        :default => 1,   :null => false
    t.integer  "tries_counter",                              :default => 0,   :null => false
    t.integer  "id_client",                                                   :null => false
    t.integer  "client_type",                                                 :null => false
    t.string   "source_number",                :limit => 32,                  :null => false
    t.string   "source_caller_id",             :limit => 32,                  :null => false
    t.string   "destination_number",           :limit => 32,                  :null => false
    t.string   "destination_caller_id",        :limit => 32,                  :null => false
    t.integer  "callback_type",                              :default => 0,   :null => false
    t.string   "source_leg_connect_wave_file",                                :null => false
    t.text     "scenario_properties",                                         :null => false
    t.integer  "primary_codec",                              :default => 0,   :null => false
    t.integer  "video_primary_codec",                        :default => 0,   :null => false
    t.integer  "fax_primary_codec",                          :default => 0,   :null => false
    t.integer  "codecs",                                     :default => 0,   :null => false
    t.integer  "id_voipswitch",                              :default => 0,   :null => false
    t.datetime "last_failure_time",                                           :null => false
  end

  add_index "callback_tasks", ["id"], :name => "IX_CallbackTasksID"

  create_table "calls", :primary_key => "id_call", :force => true do |t|
    t.integer  "id_client",                                                                          :null => false
    t.string   "ip_number",           :limit => 33,                                                  :null => false
    t.string   "caller_id",           :limit => 40,                                                  :null => false
    t.string   "called_number",       :limit => 40,                                                  :null => false
    t.datetime "call_start",                                                                         :null => false
    t.datetime "call_end",                                                                           :null => false
    t.integer  "route_type",                                                                         :null => false
    t.integer  "id_tariff",                                                                          :null => false
    t.decimal  "cost",                               :precision => 12, :scale => 4
    t.integer  "duration",                                                                           :null => false
    t.string   "tariff_prefix",       :limit => 20,                                 :default => "",  :null => false
    t.integer  "client_type",                                                                        :null => false
    t.integer  "id_route"
    t.integer  "pdd",                                                                                :null => false
    t.decimal  "costR1",                             :precision => 12, :scale => 4, :default => 0.0, :null => false
    t.decimal  "costR2",                             :precision => 12, :scale => 4, :default => 0.0, :null => false
    t.decimal  "costR3",                             :precision => 12, :scale => 4, :default => 0.0, :null => false
    t.decimal  "costD",                              :precision => 12, :scale => 4, :default => 0.0, :null => false
    t.integer  "id_reseller",                                                       :default => -1,  :null => false
    t.string   "tariffdesc",          :limit => 100,                                :default => "",  :null => false
    t.integer  "id_cc",               :limit => 8,                                  :default => 0,   :null => false
    t.decimal  "ratio",                              :precision => 12, :scale => 4, :default => 1.0, :null => false
    t.integer  "client_pdd",                                                        :default => 0,   :null => false
    t.string   "orig_call_id",        :limit => 100,                                :default => "",  :null => false
    t.string   "term_call_id",        :limit => 100,                                :default => "",  :null => false
    t.integer  "id_callback_call",    :limit => 8,                                  :default => 0,   :null => false
    t.integer  "id_cn",               :limit => 8,                                  :default => 0,   :null => false
    t.string   "dialing_plan_prefix", :limit => 50,                                 :default => "",  :null => false
    t.decimal  "call_rate",                          :precision => 8,  :scale => 4, :default => 0.0, :null => false
    t.integer  "effective_duration",                                                :default => 0,   :null => false
    t.string   "dtmf",                                                              :default => "",  :null => false
    t.integer  "call_data",                                                         :default => 0,   :null => false
    t.string   "tariff_data",                                                       :default => "",  :null => false
  end

  add_index "calls", ["call_start"], :name => "IX_CallsCallStart"
  add_index "calls", ["client_type"], :name => "IX_CallsClientType"
  add_index "calls", ["id_cc"], :name => "UQ_CallsIDCC", :unique => true
  add_index "calls", ["id_client"], :name => "IX_CallsIDClient"
  add_index "calls", ["id_reseller"], :name => "IX_CallsResellers"
  add_index "calls", ["id_tariff"], :name => "IX_CallsIDTariff"

# Could not dump table "calls_all" because of following ActiveRecord::StatementInvalid
#   Mysql2::Error: SHOW VIEW command denied to user 'resell'@'107-1-109-42-ip-static.hfc.comcastbusiness.net' for table 'calls_all': SHOW CREATE TABLE `calls_all`

  create_table "calls_costs", :force => true do |t|
    t.integer "id_cc",              :limit => 8,                                  :default => 0,   :null => false
    t.integer "cost_type",                                                        :default => 1,   :null => false
    t.integer "id_client",                                                                         :null => false
    t.integer "client_type",                                                                       :null => false
    t.integer "id_tariff",                                                                         :null => false
    t.decimal "cost",                              :precision => 12, :scale => 4
    t.integer "duration",                                                                          :null => false
    t.integer "effective_duration",                                               :default => 0,   :null => false
    t.string  "tariff_prefix",      :limit => 20,                                 :default => "",  :null => false
    t.string  "tariffdesc",         :limit => 100,                                :default => "",  :null => false
    t.decimal "ratio",                             :precision => 12, :scale => 4, :default => 1.0, :null => false
    t.decimal "call_rate",                         :precision => 8,  :scale => 4, :default => 0.0, :null => false
  end

  add_index "calls_costs", ["client_type"], :name => "IX_CallsCostsClientType"
  add_index "calls_costs", ["cost_type"], :name => "IX_CallsCostsType"
  add_index "calls_costs", ["id_cc"], :name => "IX_CallsCostsIDCC"
  add_index "calls_costs", ["id_client"], :name => "IX_CallsCostsIDClient"
  add_index "calls_costs", ["id_tariff"], :name => "IX_CallsCostsIDTariff"

  create_table "callsarchives", :primary_key => "tableName", :force => true do |t|
    t.datetime "firstCall"
    t.datetime "lastCall"
    t.integer  "callsCount"
  end

  create_table "callscallshop", :primary_key => "id_call", :force => true do |t|
    t.integer  "id_client",                                                                          :null => false
    t.string   "ip_number",           :limit => 33,                                                  :null => false
    t.string   "caller_id",           :limit => 40,                                                  :null => false
    t.string   "called_number",       :limit => 40,                                                  :null => false
    t.datetime "call_start",                                                                         :null => false
    t.datetime "call_end",                                                                           :null => false
    t.integer  "route_type",                                                                         :null => false
    t.integer  "id_tariff",                                                                          :null => false
    t.decimal  "cost",                               :precision => 12, :scale => 4
    t.integer  "duration",                                                                           :null => false
    t.string   "tariff_prefix",       :limit => 20,                                 :default => "",  :null => false
    t.integer  "client_type",                                                                        :null => false
    t.integer  "id_route"
    t.integer  "pdd",                                                                                :null => false
    t.decimal  "costR1",                             :precision => 12, :scale => 4, :default => 0.0, :null => false
    t.decimal  "costR2",                             :precision => 12, :scale => 4, :default => 0.0, :null => false
    t.decimal  "costR3",                             :precision => 12, :scale => 4, :default => 0.0, :null => false
    t.decimal  "costD",                              :precision => 12, :scale => 4, :default => 0.0, :null => false
    t.integer  "id_reseller",                                                       :default => -1,  :null => false
    t.string   "tariffdesc",          :limit => 100,                                :default => "",  :null => false
    t.integer  "id_cc",               :limit => 8,                                  :default => 0,   :null => false
    t.decimal  "ratio",                              :precision => 12, :scale => 4, :default => 1.0, :null => false
    t.integer  "invoice_id",                                                        :default => -1,  :null => false
    t.integer  "client_pdd",                                                        :default => 0,   :null => false
    t.string   "orig_call_id",        :limit => 100,                                :default => "",  :null => false
    t.string   "term_call_id",        :limit => 100,                                :default => "",  :null => false
    t.integer  "id_callback_call",    :limit => 8,                                  :default => 0,   :null => false
    t.integer  "id_cn",               :limit => 8,                                  :default => 0,   :null => false
    t.string   "dialing_plan_prefix", :limit => 50,                                 :default => "",  :null => false
    t.decimal  "call_rate",                          :precision => 8,  :scale => 4, :default => 0.0, :null => false
    t.integer  "effective_duration",                                                :default => 0,   :null => false
    t.integer  "call_data",                                                         :default => 0,   :null => false
    t.string   "dtmf",                                                              :default => "",  :null => false
  end

  add_index "callscallshop", ["id_cc"], :name => "IX_CallsCallshop_Idcc"

  create_table "callsfailed", :primary_key => "id_failed_call", :force => true do |t|
    t.integer  "id_client",                                          :null => false
    t.string   "ip_number",           :limit => 33,                  :null => false
    t.string   "caller_id",           :limit => 40,                  :null => false
    t.string   "called_number",       :limit => 40,                  :null => false
    t.datetime "call_start",                                         :null => false
    t.integer  "route_type",                                         :null => false
    t.integer  "IE_error_number",                                    :null => false
    t.integer  "release_reason",                                     :null => false
    t.integer  "client_type",                                        :null => false
    t.integer  "id_route",                                           :null => false
    t.integer  "pdd",                                                :null => false
    t.integer  "type",                                               :null => false
    t.string   "tariff_prefix",       :limit => 20,  :default => "", :null => false
    t.integer  "id_tariff",                          :default => 0,  :null => false
    t.string   "tariffdesc",          :limit => 100, :default => "", :null => false
    t.integer  "id_reseller",                        :default => -1, :null => false
    t.string   "orig_call_id",        :limit => 100, :default => "", :null => false
    t.string   "term_call_id",        :limit => 100, :default => "", :null => false
    t.integer  "id_cc",               :limit => 8,   :default => 0,  :null => false
    t.string   "dialing_plan_prefix", :limit => 50,  :default => "", :null => false
    t.integer  "id_cn",               :limit => 8,   :default => 0,  :null => false
    t.integer  "id_callback_call",    :limit => 8,   :default => 0,  :null => false
    t.string   "dtmf",                               :default => "", :null => false
    t.integer  "call_data",                          :default => 0,  :null => false
  end

  add_index "callsfailed", ["call_start"], :name => "IX_CallsFailedCallStart"
  add_index "callsfailed", ["client_type"], :name => "IX_CallsFailedClientType"
  add_index "callsfailed", ["route_type"], :name => "IX_CallsFailedRouteType"

# Could not dump table "callshopcalls_list" because of following ActiveRecord::StatementInvalid
#   Mysql2::Error: SHOW VIEW command denied to user 'resell'@'107-1-109-42-ip-static.hfc.comcastbusiness.net' for table 'callshopcalls_list': SHOW CREATE TABLE `callshopcalls_list`

# Could not dump table "callshopcurrentcalls_list" because of following ActiveRecord::StatementInvalid
#   Mysql2::Error: SHOW VIEW command denied to user 'resell'@'107-1-109-42-ip-static.hfc.comcastbusiness.net' for table 'callshopcurrentcalls_list': SHOW CREATE TABLE `callshopcurrentcalls_list`

  create_table "callshopusers", :primary_key => "id_callshopuser", :force => true do |t|
    t.integer "id_callshop", :null => false
    t.integer "id_client",   :null => false
    t.integer "client_type", :null => false
  end

  create_table "chargetoclient", :id => false, :force => true do |t|
    t.decimal "Amount",     :precision => 18, :scale => 2, :null => false
    t.integer "ClientType",                                :null => false
  end

  create_table "chargetypes", :primary_key => "Amount", :force => true do |t|
    t.string  "Description",     :limit => 50
    t.string  "DescriptionLong", :limit => 2000
    t.boolean "flagCreate",                      :default => true, :null => false
    t.boolean "flagCharge",                      :default => true, :null => false
  end

  create_table "cli_map", :force => true do |t|
    t.text "name"
  end

  create_table "cli_map_records", :force => true do |t|
    t.integer "id_cli_map",                  :null => false
    t.string  "input_pattern", :limit => 64, :null => false
    t.text    "cli",                         :null => false
    t.text    "display_name",                :null => false
    t.integer "input_type",                  :null => false
  end

  add_index "cli_map_records", ["id_cli_map", "input_type", "input_pattern"], :name => "IX_CliMapRecordsSearch"
  add_index "cli_map_records", ["id_cli_map"], :name => "IX_CliMapRecordsIdCliMap"

  create_table "click2call", :force => true do |t|
    t.string  "phone_number",         :limit => 45
    t.integer "id_client"
    t.integer "client_type"
    t.integer "register_id_client"
    t.integer "register_client_type"
    t.string  "referrer_url",         :limit => 200
  end

  add_index "click2call", ["phone_number"], :name => "uk_phone", :unique => true

# Could not dump table "client_dids" because of following ActiveRecord::StatementInvalid
#   Mysql2::Error: SHOW VIEW command denied to user 'resell'@'107-1-109-42-ip-static.hfc.comcastbusiness.net' for table 'client_dids': SHOW CREATE TABLE `client_dids`

  create_table "client_properties", :id => false, :force => true do |t|
    t.integer "id_client",                   :null => false
    t.integer "client_type",                 :null => false
    t.integer "id_group",                    :null => false
    t.string  "properties",   :limit => 512, :null => false
    t.text    "dtmf_actions"
    t.text    "audio_events"
  end

  create_table "clientinf", :id => false, :force => true do |t|
    t.integer  "id_client",                     :default => 0,  :null => false
    t.integer  "client_type",                   :default => -1, :null => false
    t.integer  "id_lot",                        :default => 0,  :null => false
    t.integer  "serial"
    t.string   "serial2",         :limit => 20, :default => "", :null => false
    t.string   "pin",             :limit => 20
    t.datetime "activation_date"
    t.datetime "expiry_date"
  end

  add_index "clientinf", ["client_type"], :name => "IC_ClientInfClientType"
  add_index "clientinf", ["id_lot"], :name => "IC_ClientInfLot"
  add_index "clientinf", ["pin"], :name => "UQ_ClientInfPin", :unique => true

  create_table "clientscallback", :primary_key => "id_client", :force => true do |t|
    t.string  "login",                :limit => 20,                                :default => "",  :null => false
    t.string  "password",             :limit => 40,                                                 :null => false
    t.integer "type",                                                              :default => 0,   :null => false
    t.integer "id_tariff",                                                         :default => 0,   :null => false
    t.decimal "account_state",                      :precision => 12, :scale => 4, :default => 0.0, :null => false
    t.text    "tech_prefix",                                                                        :null => false
    t.integer "id_reseller",                                                       :default => -1,  :null => false
    t.integer "type2",                                                             :default => 0,   :null => false
    t.integer "type3",                                                             :default => 0,   :null => false
    t.integer "id_intrastate_tariff",                                              :default => -1,  :null => false
    t.integer "id_currency",                                                       :default => 1,   :null => false
    t.string  "free_seconds",                                                      :default => "",  :null => false
    t.integer "id_cli_map",                                                        :default => 0,   :null => false
  end

  add_index "clientscallback", ["id_currency"], :name => "IX_ClientsCallBackCurrency"
  add_index "clientscallback", ["id_reseller"], :name => "IX_ClientsCallBackReseller"
  add_index "clientscallback", ["id_tariff"], :name => "IX_ClientsCallBackTariffs"
  add_index "clientscallback", ["login"], :name => "UQ_ClientsCallBackLogin", :unique => true
  add_index "clientscallback", ["password"], :name => "IX_ClientsCallBackPassword"

  create_table "clientscallbackphones", :force => true do |t|
    t.integer "id_client",                                 :null => false
    t.string  "phone_number", :limit => 50,                :null => false
    t.integer "def",          :limit => 2,  :default => 0, :null => false
    t.integer "client_type",                :default => 4, :null => false
  end

  add_index "clientscallbackphones", ["id_client", "phone_number", "client_type"], :name => "UQ_ClientCallBackPhone", :unique => true
  add_index "clientscallbackphones", ["phone_number"], :name => "IX_ClientCallBackPhone"

  create_table "clientscallshop", :primary_key => "id_client", :force => true do |t|
    t.string  "login",                :limit => 20,                                                 :null => false
    t.string  "password",             :limit => 40,                                                 :null => false
    t.integer "type",                                                              :default => 1,   :null => false
    t.integer "id_tariff",                                                                          :null => false
    t.decimal "account_state",                      :precision => 12, :scale => 4, :default => 0.0, :null => false
    t.integer "id_reseller",                                                       :default => -1,  :null => false
    t.integer "id_intrastate_tariff",                                              :default => -1,  :null => false
    t.text    "tech_prefix",                                                                        :null => false
    t.integer "id_currency",                                                       :default => 1,   :null => false
    t.integer "template_id",                                                       :default => -1,  :null => false
    t.string  "free_seconds",                                                      :default => "",  :null => false
    t.integer "id_cli_map",                                                        :default => 0,   :null => false
  end

  add_index "clientscallshop", ["id_currency"], :name => "IX_ClientsCallshopCurrency"
  add_index "clientscallshop", ["id_reseller"], :name => "IX_ClientsCallshopReseller"
  add_index "clientscallshop", ["id_tariff"], :name => "IX_ClientsCallshopTariffs"
  add_index "clientscallshop", ["login"], :name => "UQ_ClientsCallshopLogin", :unique => true
  add_index "clientscallshop", ["password"], :name => "IX_ClientsCallshopPassword"

  create_table "clientse164", :primary_key => "id_client", :force => true do |t|
    t.string  "login",                :limit => 20,                                                :null => false
    t.string  "password",             :limit => 20,                                                :null => false
    t.integer "type",                                                                              :null => false
    t.integer "id_tariff",                                                                         :null => false
    t.decimal "account_state",                      :precision => 12, :scale => 4,                 :null => false
    t.text    "tech_prefix",                                                                       :null => false
    t.integer "id_reseller",                                                       :default => -1, :null => false
    t.integer "type2",                                                             :default => 0,  :null => false
    t.integer "type3",                                                             :default => 0,  :null => false
    t.integer "id_intrastate_tariff",                                              :default => -1, :null => false
    t.integer "id_currency",                                                       :default => 1,  :null => false
    t.integer "codecs",                                                            :default => 0,  :null => false
    t.integer "primary_codec",                                                     :default => 0,  :null => false
    t.string  "free_seconds",                                                      :default => "", :null => false
    t.integer "video_codecs",                                                      :default => 0,  :null => false
    t.integer "video_primary_codec",                                               :default => 0,  :null => false
    t.integer "fax_codecs",                                                        :default => 0,  :null => false
    t.integer "fax_primary_codec",                                                 :default => 0,  :null => false
  end

  add_index "clientse164", ["login"], :name => "IX_ClientsLoginsE", :unique => true

  create_table "clientshearlink", :primary_key => "id_client", :force => true do |t|
    t.string  "login",                :limit => 100,                                                :null => false
    t.string  "password",             :limit => 20,                                                 :null => false
    t.integer "type",                                                                               :null => false
    t.integer "id_tariff",                                                                          :null => false
    t.decimal "account_state",                       :precision => 12, :scale => 4,                 :null => false
    t.text    "tech_prefix",                                                                        :null => false
    t.integer "id_reseller",                                                        :default => -1, :null => false
    t.integer "type2",                                                              :default => 0,  :null => false
    t.integer "type3",                                                              :default => 0,  :null => false
    t.integer "id_intrastate_tariff",                                               :default => -1, :null => false
    t.integer "id_currency",                                                        :default => 1,  :null => false
    t.string  "free_seconds",                                                       :default => "", :null => false
  end

  add_index "clientshearlink", ["login"], :name => "IX_ClientsLoginsH", :unique => true

  create_table "clientsip", :primary_key => "id_client", :force => true do |t|
    t.string  "login",                :limit => 20,                                                :null => false
    t.string  "password",             :limit => 40,                                                :null => false
    t.integer "type",                                                                              :null => false
    t.integer "id_tariff",                                                                         :null => false
    t.decimal "account_state",                      :precision => 12, :scale => 4,                 :null => false
    t.text    "tech_prefix",                                                                       :null => false
    t.integer "id_reseller",                                                       :default => -1, :null => false
    t.integer "type2",                                                             :default => 0,  :null => false
    t.integer "type3",                                                             :default => 0,  :null => false
    t.integer "id_intrastate_tariff",                                              :default => -1, :null => false
    t.integer "id_currency",                                                       :default => 1,  :null => false
    t.integer "codecs",                                                            :default => 0,  :null => false
    t.integer "primary_codec",                                                     :default => 0,  :null => false
    t.string  "free_seconds",                                                      :default => "", :null => false
    t.integer "limit_cps",                                                         :default => 0,  :null => false
    t.integer "video_codecs",                                                      :default => 0,  :null => false
    t.integer "video_primary_codec",                                               :default => 0,  :null => false
    t.integer "fax_codecs",                                                        :default => 0,  :null => false
    t.integer "fax_primary_codec",                                                 :default => 0,  :null => false
    t.integer "id_cli_map",                                                        :default => 0,  :null => false
  end

  add_index "clientsip", ["id_currency"], :name => "IX_ClientsIPCurrency"
  add_index "clientsip", ["id_reseller"], :name => "IX_ClientsIPReseller"
  add_index "clientsip", ["id_tariff"], :name => "IX_ClientsIPTariffs"
  add_index "clientsip", ["login"], :name => "UQ_ClientsIPLogin", :unique => true
  add_index "clientsip", ["password"], :name => "IX_ClientsIPPassword"

  create_table "clientspayments", :id => false, :force => true do |t|
    t.integer  "IDClient",                                 :null => false
    t.integer  "Type",                                     :null => false
    t.datetime "Date_",                                    :null => false
    t.decimal  "Amount",    :precision => 18, :scale => 4, :null => false
    t.integer  "IDPayment",                                :null => false
  end

# Could not dump table "clientspbx" because of following ActiveRecord::StatementInvalid
#   Mysql2::Error: SHOW VIEW command denied to user 'resell'@'107-1-109-42-ip-static.hfc.comcastbusiness.net' for table 'clientspbx': SHOW CREATE TABLE `clientspbx`

  create_table "clientspin", :primary_key => "id_client", :force => true do |t|
    t.string  "login",                :limit => 20,                                :default => "",  :null => false
    t.string  "password",             :limit => 40,                                                 :null => false
    t.string  "web_password",         :limit => 40,                                :default => "",  :null => false
    t.integer "type",                                                              :default => 0,   :null => false
    t.integer "id_tariff",                                                         :default => 0,   :null => false
    t.decimal "account_state",                      :precision => 12, :scale => 4, :default => 0.0, :null => false
    t.text    "tech_prefix",                                                                        :null => false
    t.integer "id_reseller",                                                       :default => -1,  :null => false
    t.integer "type2",                                                             :default => 0,   :null => false
    t.integer "type3",                                                             :default => 0,   :null => false
    t.integer "id_intrastate_tariff",                                              :default => -1,  :null => false
    t.integer "id_currency",                                                       :default => 1,   :null => false
    t.string  "free_seconds",                                                      :default => "",  :null => false
    t.integer "id_cli_map",                                                        :default => 0,   :null => false
  end

  add_index "clientspin", ["id_currency"], :name => "IX_ClientsPinCurrency"
  add_index "clientspin", ["id_reseller"], :name => "IX_ClientsPinReseller"
  add_index "clientspin", ["id_tariff"], :name => "IX_ClientsPinTariffs"
  add_index "clientspin", ["login"], :name => "UQ_ClientsPinLogin", :unique => true
  add_index "clientspin", ["password"], :name => "IX_ClientsPinPassword"
  add_index "clientspin", ["web_password"], :name => "IX_ClientsPinWebPassword"

# Could not dump table "clientsretail" because of following ActiveRecord::StatementInvalid
#   Mysql2::Error: SHOW VIEW command denied to user 'resell'@'107-1-109-42-ip-static.hfc.comcastbusiness.net' for table 'clientsretail': SHOW CREATE TABLE `clientsretail`

  create_table "clientsshared", :primary_key => "id_client", :force => true do |t|
    t.string  "login",                :limit => 20,                                :default => "",  :null => false
    t.string  "password",             :limit => 40,                                                 :null => false
    t.string  "web_password",         :limit => 40,                                :default => "",  :null => false
    t.integer "type",                                                              :default => 0,   :null => false
    t.integer "id_tariff",                                                         :default => 0,   :null => false
    t.decimal "account_state",                      :precision => 12, :scale => 4, :default => 0.0, :null => false
    t.text    "tech_prefix",                                                                        :null => false
    t.integer "id_reseller",                                                       :default => -1,  :null => false
    t.integer "type2",                                                             :default => 0,   :null => false
    t.integer "type3",                                                             :default => 0,   :null => false
    t.integer "id_intrastate_tariff",                                              :default => -1,  :null => false
    t.integer "id_currency",                                                       :default => 1,   :null => false
    t.integer "codecs",                                                            :default => 0,   :null => false
    t.integer "primary_codec",                                                     :default => 0,   :null => false
    t.string  "free_seconds",                                                      :default => "",  :null => false
    t.integer "id_tariff_vod",                                                     :default => 0,   :null => false
    t.integer "video_codecs",                                                      :default => 0,   :null => false
    t.integer "video_primary_codec",                                               :default => 0,   :null => false
    t.integer "fax_codecs",                                                        :default => 0,   :null => false
    t.integer "fax_primary_codec",                                                 :default => 0,   :null => false
    t.integer "id_cli_map",                                                        :default => 0,   :null => false
  end

  add_index "clientsshared", ["id_currency"], :name => "IX_ClientsSharedCurrency"
  add_index "clientsshared", ["id_reseller"], :name => "IX_ClientsSharedReseller"
  add_index "clientsshared", ["id_tariff"], :name => "IX_ClientsSharedTariffs"
  add_index "clientsshared", ["login"], :name => "UQ_ClientsSharedLogin", :unique => true
  add_index "clientsshared", ["password"], :name => "IX_ClientsSharedPassword"
  add_index "clientsshared", ["web_password"], :name => "IX_ClientsSharedWebPassword"

  create_table "clienttypes", :primary_key => "id_client_type", :force => true do |t|
    t.string "client_type_name", :limit => 50, :null => false
  end

  create_table "codecs", :force => true do |t|
    t.integer "id_codec",                                            :null => false
    t.string  "description",          :limit => 20,  :default => "", :null => false
    t.integer "payload_type",                                        :null => false
    t.string  "sip_rtpmap",           :limit => 100,                 :null => false
    t.string  "sip_codec_string",     :limit => 100,                 :null => false
    t.string  "sip_codec_parameter",  :limit => 100,                 :null => false
    t.integer "voipbox_payload_size",                                :null => false
    t.string  "voipbox_file_suffix",  :limit => 20,                  :null => false
    t.integer "voipbox_wait",                        :default => 0,  :null => false
    t.integer "voipbox_time_step",                   :default => 0,  :null => false
    t.integer "wave_file_format",                    :default => 0,  :null => false
    t.float   "ms_per_byte",                                         :null => false
    t.string  "sdp_parameters",       :limit => 500, :default => "", :null => false
    t.integer "codec_type",                          :default => 0,  :null => false
  end

  add_index "codecs", ["id_codec"], :name => "UQ_CodecsIdCodec", :unique => true

  create_table "companies", :force => true do |t|
    t.string "name",    :limit => 200
    t.string "address"
    t.string "zip",     :limit => 50
    t.string "city",    :limit => 100
    t.string "country", :limit => 100
    t.string "email"
    t.string "phone"
    t.string "phone1"
  end

  create_table "companiesclients", :id => false, :force => true do |t|
    t.integer "id_company",  :null => false
    t.integer "id_client",   :null => false
    t.integer "client_type", :null => false
  end

  create_table "coststypes", :force => true do |t|
    t.string "name", :limit => 50, :null => false
  end

  create_table "countries", :primary_key => "iso2", :force => true do |t|
    t.string  "name",                                                         :null => false
    t.string  "iso3",                                                         :null => false
    t.integer "iso_code",          :limit => 2,                               :null => false
    t.string  "currency",                                                     :null => false
    t.string  "currency_code",                                                :null => false
    t.decimal "time_zone_offsets",              :precision => 3, :scale => 1
  end

  create_table "credit_card_data", :force => true do |t|
    t.integer "client_type",                                                                 :null => false
    t.integer "id_client",                                                                   :null => false
    t.string  "card_info",    :limit => 30,                                 :default => "",  :null => false
    t.string  "card_number",  :limit => 64,                                                  :null => false
    t.string  "card_code",    :limit => 64,                                                  :null => false
    t.string  "card_date",    :limit => 64,                                                  :null => false
    t.string  "first_name",   :limit => 32,                                                  :null => false
    t.string  "last_name",    :limit => 32,                                                  :null => false
    t.string  "country",      :limit => 100,                                                 :null => false
    t.string  "street",       :limit => 64,                                                  :null => false
    t.string  "city",         :limit => 32,                                                  :null => false
    t.string  "state",        :limit => 32,                                                  :null => false
    t.string  "zip",          :limit => 16,                                                  :null => false
    t.integer "payment_type",                                               :default => -1,  :null => false
    t.decimal "low_amount",                  :precision => 12, :scale => 2, :default => 0.0, :null => false
    t.decimal "amount",                      :precision => 12, :scale => 2, :default => 0.0, :null => false
  end

  create_table "currencies", :force => true do |t|
    t.decimal  "ratio",       :precision => 12, :scale => 4, :default => 1.0, :null => false
    t.integer  "id_currency",                                                 :null => false
    t.datetime "date",                                                        :null => false
  end

  add_index "currencies", ["id_currency", "date"], :name => "id_currency"

  create_table "currency_names", :force => true do |t|
    t.string "name",   :limit => 50,                 :null => false
    t.string "symbol", :limit => 5,  :default => "", :null => false
  end

  create_table "currentcalls", :primary_key => "id_call", :force => true do |t|
    t.integer  "id_active_call",   :limit => 8,                                 :default => 0,   :null => false
    t.integer  "id_client",                                                     :default => 0,   :null => false
    t.string   "dialed_number",    :limit => 40,                                :default => "",  :null => false
    t.datetime "call_start",                                                                     :null => false
    t.integer  "client_type",                                                   :default => 0,   :null => false
    t.string   "ani",              :limit => 40,                                :default => "",  :null => false
    t.integer  "id_route",                                                      :default => 0,   :null => false
    t.integer  "route_type",                                                    :default => 0,   :null => false
    t.integer  "id_reseller",                                                   :default => 0,   :null => false
    t.string   "tariffdesc",       :limit => 100,                               :default => "",  :null => false
    t.integer  "id_cabin",                                                      :default => -1,  :null => false
    t.integer  "cabin_type",                                                    :default => -1,  :null => false
    t.integer  "id_cc",            :limit => 8,                                 :default => 0,   :null => false
    t.integer  "id_callback_call", :limit => 8,                                 :default => 0,   :null => false
    t.decimal  "call_rate",                       :precision => 8, :scale => 4, :default => 0.0, :null => false
    t.integer  "id_voipswitch",                                                 :default => 1,   :null => false
    t.integer  "state",                                                         :default => 3,   :null => false
  end

  create_table "dialingplan", :primary_key => "id_dialplan", :force => true do |t|
    t.string  "telephone_number", :limit => 40,   :default => "",   :null => false
    t.integer "priority",         :limit => 2,                      :null => false
    t.integer "route_type",                                         :null => false
    t.text    "tech_prefix",                                        :null => false
    t.string  "dial_as",          :limit => 40,   :default => "",   :null => false
    t.integer "id_route",                                           :null => false
    t.integer "call_type",                                          :null => false
    t.integer "type",                                               :null => false
    t.integer "from_day",         :limit => 2,    :default => 0,    :null => false
    t.integer "to_day",           :limit => 2,    :default => 6,    :null => false
    t.integer "from_hour",        :limit => 2,    :default => 0,    :null => false
    t.integer "to_hour",          :limit => 2,    :default => 2400, :null => false
    t.integer "balance_share",                    :default => 100,  :null => false
    t.string  "fields",           :limit => 1024, :default => "",   :null => false
    t.integer "call_limit",                       :default => 0,    :null => false
  end

  add_index "dialingplan", ["priority"], :name => "IX_DialingPlanPriority"
  add_index "dialingplan", ["telephone_number"], :name => "IX_DialingPlanNumber"

# Could not dump table "dialingplan_lcr" because of following ActiveRecord::StatementInvalid
#   Mysql2::Error: SHOW VIEW command denied to user 'resell'@'107-1-109-42-ip-static.hfc.comcastbusiness.net' for table 'dialingplan_lcr': SHOW CREATE TABLE `dialingplan_lcr`

  create_table "didcallback", :id => false, :force => true do |t|
    t.string  "didnumber",    :limit => 50, :null => false
    t.string  "clientnumber", :limit => 50, :null => false
    t.integer "id_client",                  :null => false
    t.integer "client_type",                :null => false
  end

  create_table "em_alerts_config", :force => true do |t|
    t.string  "name",        :limit => 50,                   :null => false
    t.text    "definition",                                  :null => false
    t.string  "description", :limit => 200
    t.integer "alert_type",                                  :null => false
    t.string  "enable",      :limit => 1,   :default => "0", :null => false
  end

  add_index "em_alerts_config", ["name"], :name => "IX_name", :unique => true

  create_table "em_aps_history", :force => true do |t|
    t.integer  "id_aps_schedule",                    :null => false
    t.integer  "aps_status",                         :null => false
    t.datetime "created_at",                         :null => false
    t.string   "aps_status_comment", :limit => 2048
    t.integer  "history_status",                     :null => false
  end

  add_index "em_aps_history", ["id_aps_schedule"], :name => "IX_EmApsHistoryIdSchedule"

  create_table "em_aps_schedule", :force => true do |t|
    t.integer  "id_client",                                                                          :null => false
    t.integer  "client_type",                                                                        :null => false
    t.integer  "payment_day",                                                                        :null => false
    t.integer  "payment_reminder"
    t.datetime "start_date",                                                                         :null => false
    t.datetime "next_date",                                                                          :null => false
    t.datetime "end_date",                                                                           :null => false
    t.integer  "aps_type",                                                                           :null => false
    t.string   "aps_data",           :limit => 200,                                                  :null => false
    t.decimal  "payment_amount",                    :precision => 12, :scale => 4, :default => -1.0, :null => false
    t.integer  "aps_status",                                                       :default => 0,    :null => false
    t.string   "client_tech_prefix", :limit => 512,                                :default => "",   :null => false
  end

  add_index "em_aps_schedule", ["client_type"], :name => "IX_EmApsScheduleClientType"
  add_index "em_aps_schedule", ["id_client"], :name => "IX_EmApsScheduleIdClient"

# Could not dump table "em_aps_time_table" because of following ActiveRecord::StatementInvalid
#   Mysql2::Error: SHOW VIEW command denied to user 'resell'@'107-1-109-42-ip-static.hfc.comcastbusiness.net' for table 'em_aps_time_table': SHOW CREATE TABLE `em_aps_time_table`

  create_table "em_aps_types", :force => true do |t|
    t.string  "name",        :limit => 50,                                                   :null => false
    t.string  "description", :limit => 200
    t.text    "definition"
    t.decimal "amount",                     :precision => 12, :scale => 4, :default => -1.0, :null => false
    t.integer "period",                                                    :default => -1,   :null => false
  end

  create_table "em_client_config", :force => true do |t|
    t.integer "id_client",                :null => false
    t.integer "client_type",              :null => false
    t.integer "id_job_type",              :null => false
    t.binary  "enable",      :limit => 1, :null => false
  end

  create_table "em_clients_jobs", :force => true do |t|
    t.integer "id_job_type", :null => false
    t.integer "client_type", :null => false
  end

  create_table "em_job_types", :force => true do |t|
    t.string   "name",            :limit => 50,  :default => "",                    :null => false
    t.string   "enable",          :limit => 1,                                      :null => false
    t.string   "client_enable",   :limit => 1,                                      :null => false
    t.string   "description",     :limit => 100
    t.integer  "repeat_count",    :limit => 8,   :default => 0,                     :null => false
    t.integer  "repeat_interval", :limit => 8,   :default => 0,                     :null => false
    t.integer  "log_type",                       :default => 0,                     :null => false
    t.datetime "next_time",                      :default => '1900-01-01 00:00:00', :null => false
    t.datetime "prev_time",                      :default => '1900-01-01 00:00:00', :null => false
    t.datetime "start_time",                     :default => '1900-01-01 00:00:00', :null => false
    t.datetime "end_time",                       :default => '1900-01-01 00:00:00', :null => false
  end

  create_table "em_tasks", :force => true do |t|
    t.integer "id_job_type",                 :null => false
    t.integer "id_job_mode",                 :null => false
    t.string  "context",     :limit => 2048, :null => false
  end

  create_table "em_vmn_clients", :force => true do |t|
    t.integer "id_client",                                       :null => false
    t.integer "client_type",                                     :null => false
    t.string  "caller_id",       :limit => 40,  :default => ""
    t.integer "delivery_method",                                 :null => false
    t.string  "delivery_to",     :limit => 200, :default => "",  :null => false
    t.string  "time_start",      :limit => 5,   :default => "",  :null => false
    t.string  "time_stop",       :limit => 5,   :default => "",  :null => false
    t.string  "days",            :limit => 20,  :default => "0", :null => false
    t.integer "notify_type",                    :default => 1,   :null => false
  end

  add_index "em_vmn_clients", ["id_client", "client_type"], :name => "IX_EM_VMN_ClientsConfig"

  create_table "em_vmn_clients_book", :force => true do |t|
    t.integer "id_client",                  :null => false
    t.integer "client_type",                :null => false
    t.integer "book_type",                  :null => false
    t.string  "book_item",   :limit => 200
  end

  create_table "email_templates", :force => true do |t|
    t.integer "template_type",                              :null => false
    t.integer "type",                       :default => 0,  :null => false
    t.string  "language",      :limit => 2, :default => "", :null => false
    t.text    "msg_body",                                   :null => false
    t.text    "msg_title",                                  :null => false
    t.string  "sender_name",                :default => "", :null => false
    t.string  "reply_to",                   :default => "", :null => false
  end

  create_table "enumroots", :primary_key => "id_route", :force => true do |t|
    t.string  "description", :default => "", :null => false
    t.string  "ip_number",   :default => "", :null => false
    t.integer "type",        :default => -1, :null => false
  end

  create_table "fax_banners", :force => true do |t|
    t.integer "id_client",   :null => false
    t.integer "client_type", :null => false
    t.string  "header_text", :null => false
    t.string  "filename",    :null => false
  end

  add_index "fax_banners", ["id_client"], :name => "IX_FaxBannersClientID"

  create_table "fax_client_config", :force => true do |t|
    t.integer "id_client",                  :null => false
    t.integer "client_type",                :null => false
    t.string  "email_to_fax", :limit => 40, :null => false
    t.text    "properties",                 :null => false
  end

  add_index "fax_client_config", ["id_client", "client_type"], :name => "UK_FaxConfigClientType", :unique => true

  create_table "fax_codecs", :force => true do |t|
    t.integer "id_codec",                                            :null => false
    t.string  "description",          :limit => 20,  :default => "", :null => false
    t.integer "payload_type",                                        :null => false
    t.string  "sip_rtpmap",                          :default => "", :null => false
    t.string  "sip_codec_string",     :limit => 100,                 :null => false
    t.string  "sip_codec_parameter",  :limit => 100,                 :null => false
    t.integer "voipbox_payload_size",                                :null => false
    t.string  "voipbox_file_suffix",  :limit => 20,                  :null => false
    t.integer "voipbox_wait",                        :default => 0,  :null => false
    t.integer "voipbox_time_step",                   :default => 0,  :null => false
    t.integer "wave_file_format",                    :default => 0,  :null => false
    t.float   "ms_per_byte",                                         :null => false
    t.string  "sdp_parameters",       :limit => 500,                 :null => false
    t.integer "codec_type",                          :default => 0,  :null => false
  end

  add_index "fax_codecs", ["id_codec"], :name => "UQ_FaxCodecsIdCodec", :unique => true

  create_table "fax_failed", :force => true do |t|
    t.integer  "id_client",                                  :null => false
    t.integer  "client_type",                                :null => false
    t.string   "destination",  :limit => 32,                 :null => false
    t.string   "caller_id",    :limit => 40,                 :null => false
    t.string   "filename",                                   :null => false
    t.datetime "first_try",                                  :null => false
    t.integer  "delta_time",                 :default => 60, :null => false
    t.integer  "num_of_tries",                               :null => false
    t.text     "properties"
    t.integer  "task_status",                :default => 1
  end

  create_table "fax_history", :force => true do |t|
    t.integer  "id_client",                                   :null => false
    t.integer  "client_type",                                 :null => false
    t.string   "destination",  :limit => 32,                  :null => false
    t.string   "caller_id",    :limit => 40,                  :null => false
    t.string   "filename",                                    :null => false
    t.datetime "first_try",                                   :null => false
    t.integer  "delta_time",                 :default => 900, :null => false
    t.integer  "num_of_tries",                                :null => false
    t.text     "properties"
  end

  create_table "fax_processed", :force => true do |t|
    t.integer  "fax_task_id", :null => false
    t.datetime "try_date",    :null => false
    t.integer  "try_id",      :null => false
    t.integer  "status",      :null => false
  end

  add_index "fax_processed", ["fax_task_id"], :name => "IX_FaxProcessedFaxTaskID"

  create_table "fax_receive", :force => true do |t|
    t.integer  "id_client",                  :null => false
    t.integer  "client_type",                :null => false
    t.datetime "recv_date",                  :null => false
    t.string   "caller_id",    :limit => 40, :null => false
    t.string   "filename",                   :null => false
    t.integer  "num_of_pages",               :null => false
  end

  add_index "fax_receive", ["id_client", "client_type"], :name => "IX_FaxReceiveClientType"

  create_table "fax_send", :force => true do |t|
    t.integer  "id_client",                                  :null => false
    t.integer  "client_type",                                :null => false
    t.string   "destination",  :limit => 32,                 :null => false
    t.string   "caller_id",    :limit => 40,                 :null => false
    t.string   "filename",                                   :null => false
    t.datetime "send_date",                                  :null => false
    t.integer  "delta_time",                 :default => 60, :null => false
    t.integer  "num_of_tries",                               :null => false
    t.text     "properties"
    t.datetime "first_try"
    t.integer  "task_status",                :default => 4
  end

  create_table "fields_definitions", :force => true do |t|
    t.integer "field_type",                                :null => false
    t.string  "field_name", :limit => 40,  :default => "", :null => false
    t.string  "regex",      :limit => 100, :default => "", :null => false
    t.string  "tokens",     :limit => 100, :default => "", :null => false
  end

  create_table "gatekeepers", :primary_key => "id_route", :force => true do |t|
    t.string  "description",             :limit => 20
    t.string  "ip_number",                                              :null => false
    t.string  "h323_id",                 :limit => 100, :default => "", :null => false
    t.string  "e164_id",                 :limit => 100, :default => "", :null => false
    t.integer "ttl",                                                    :null => false
    t.string  "token",                   :limit => 10,  :default => "", :null => false
    t.integer "type",                                                   :null => false
    t.string  "gk_name",                 :limit => 100, :default => "", :null => false
    t.integer "id_tariff",                              :default => -1, :null => false
    t.string  "string1",                                :default => "", :null => false
    t.integer "call_limit",                             :default => 0,  :null => false
    t.text    "tech_prefix",                                            :null => false
    t.integer "codecs",                                 :default => 0,  :null => false
    t.integer "video_codecs",                           :default => 0,  :null => false
    t.integer "fax_codecs",                             :default => 0,  :null => false
    t.string  "authentication_name",     :limit => 100, :default => "", :null => false
    t.string  "authentication_password", :limit => 100, :default => "", :null => false
    t.integer "id_intrastate_tariff",                   :default => 0,  :null => false
    t.integer "transport_type",                         :default => 1,  :null => false
  end

  create_table "gateways", :primary_key => "id_route", :force => true do |t|
    t.string  "description",          :limit => 20,                  :null => false
    t.string  "ip_number",                                           :null => false
    t.string  "h323_id",              :limit => 100, :default => "", :null => false
    t.integer "type",                                                :null => false
    t.integer "call_limit",                          :default => 0,  :null => false
    t.integer "id_tariff",                           :default => -1, :null => false
    t.text    "tech_prefix",                                         :null => false
    t.integer "codecs",                              :default => 0,  :null => false
    t.integer "video_codecs",                        :default => 0,  :null => false
    t.integer "fax_codecs",                          :default => 0,  :null => false
    t.integer "id_intrastate_tariff",                :default => 0,  :null => false
    t.integer "transport_type",                      :default => 1,  :null => false
  end

# Could not dump table "gkregistrarroute" because of following ActiveRecord::StatementInvalid
#   Mysql2::Error: SHOW VIEW command denied to user 'resell'@'107-1-109-42-ip-static.hfc.comcastbusiness.net' for table 'gkregistrarroute': SHOW CREATE TABLE `gkregistrarroute`

  create_table "greetings", :primary_key => "id_greeting", :force => true do |t|
    t.integer "client_type", :null => false
    t.integer "id_client",   :null => false
    t.string  "file_name",   :null => false
  end

  create_table "groups", :id => false, :force => true do |t|
    t.integer "id_group",                                 :null => false
    t.string  "description", :limit => 20,                :null => false
    t.integer "group_type",                :default => 1, :null => false
  end

  create_table "history", :force => true do |t|
    t.string   "version", :limit => 100, :null => false
    t.datetime "start",                  :null => false
    t.datetime "stop",                   :null => false
  end

  create_table "intercept_clients", :force => true do |t|
    t.integer "id_client",                                 :null => false
    t.integer "client_type",               :default => 32, :null => false
    t.string  "ip_addr",     :limit => 16,                 :null => false
    t.integer "ip_port",                                   :null => false
  end

  create_table "invoiceclients", :id => false, :force => true do |t|
    t.integer  "IdClient",                                                         :null => false
    t.integer  "Type",                                                             :null => false
    t.string   "Name",          :limit => 200
    t.string   "LastName",      :limit => 100
    t.string   "Address",       :limit => 1000
    t.string   "EMail",         :limit => 500
    t.string   "Login",         :limit => 50,   :default => "",                    :null => false
    t.string   "TaxId",         :limit => 50
    t.boolean  "LastUsed",                      :default => false,                 :null => false
    t.string   "ClientNr",      :limit => 50
    t.string   "City",          :limit => 200
    t.string   "State",         :limit => 200
    t.string   "Zip",           :limit => 50
    t.string   "Country",       :limit => 100
    t.string   "PaymentCode",   :limit => 20,   :default => "",                    :null => false
    t.string   "Phone",         :limit => 30
    t.text     "CustomFields",                                                     :null => false
    t.integer  "InvoiceType",                   :default => 1,                     :null => false
    t.string   "MobilePhone",   :limit => 30
    t.datetime "Creation_Date",                 :default => '1900-01-01 00:00:00', :null => false
    t.string   "Company_Name",  :limit => 200,  :default => "",                    :null => false
    t.string   "language",      :limit => 2,    :default => "",                    :null => false
  end

  create_table "invoiceclientsoperations", :force => true do |t|
    t.integer "id_client",    :null => false
    t.integer "client_type",  :null => false
    t.integer "id_operation", :null => false
  end

  create_table "invoices", :primary_key => "InvoiceID", :force => true do |t|
    t.string   "InvoiceNr",     :limit => 50,                                                         :null => false
    t.string   "Name",          :limit => 200
    t.string   "Address"
    t.string   "EMail",         :limit => 500
    t.string   "TaxID",         :limit => 50
    t.string   "Item",          :limit => 200
    t.decimal  "Net",                                 :precision => 20, :scale => 4,                  :null => false
    t.decimal  "Gross",                               :precision => 20, :scale => 4,                  :null => false
    t.decimal  "aVAT",                                :precision => 20, :scale => 4,                  :null => false
    t.decimal  "aPST",                                :precision => 20, :scale => 4,                  :null => false
    t.decimal  "VAT",                                 :precision => 20, :scale => 4, :default => 0.0, :null => false
    t.decimal  "PST",                                 :precision => 20, :scale => 4, :default => 0.0, :null => false
    t.datetime "DateFrom"
    t.datetime "DateTo"
    t.string   "Login_",        :limit => 250,                                                        :null => false
    t.string   "FileName",      :limit => 500,                                                        :null => false
    t.integer  "Nr",                                                                                  :null => false
    t.integer  "Month_",                                                                              :null => false
    t.integer  "Year_",                                                                               :null => false
    t.datetime "Date_"
    t.string   "clientNr",      :limit => 50
    t.string   "City",          :limit => 200
    t.string   "State",         :limit => 200
    t.string   "Zip",           :limit => 50
    t.string   "Country",       :limit => 100
    t.string   "LastName",      :limit => 100
    t.integer  "CabinId",                                                            :default => 0,   :null => false
    t.integer  "id_client",                                                          :default => -1,  :null => false
    t.integer  "client_type",                                                        :default => -1,  :null => false
    t.integer  "template_id",                                                        :default => -1,  :null => false
    t.text     "ext_data",      :limit => 2147483647
    t.decimal  "account_state",                       :precision => 12, :scale => 4, :default => 0.0, :null => false
  end

  create_table "invoicetolots", :primary_key => "IDLot", :force => true do |t|
  end

  create_table "ip_black_list", :id => false, :force => true do |t|
    t.string "ip_black",               :limit => 15, :null => false
    t.string "ip_voipswitch_listener", :limit => 15, :null => false
  end

  create_table "ipnumbers", :primary_key => "id_ip", :force => true do |t|
    t.string  "ip_number",   :limit => 16, :null => false
    t.integer "id_client",                 :null => false
    t.text    "tech_prefix"
  end

  add_index "ipnumbers", ["ip_number"], :name => "IX_ClientsIPNumber"

  create_table "languages", :force => true do |t|
    t.string "name", :limit => 100, :default => "", :null => false
  end

  create_table "lookups", :force => true do |t|
    t.string "description",  :null => false
    t.string "query_string", :null => false
    t.string "string1",      :null => false
    t.string "string2",      :null => false
  end

  create_table "lotreseller", :primary_key => "id_lot", :force => true do |t|
    t.integer "id_reseller", :default => 0, :null => false
  end

  create_table "lots", :primary_key => "id_lot", :force => true do |t|
    t.string   "lot_desc",      :limit => 20,                                    :null => false
    t.datetime "creation_date",                                                  :null => false
    t.integer  "client_type",                 :default => 1,                     :null => false
    t.datetime "expiry_date",                 :default => '9999-12-31 23:59:59', :null => false
    t.integer  "active_time",                 :default => -1,                    :null => false
    t.integer  "active_period",               :default => 1,                     :null => false
  end

  add_index "lots", ["lot_desc"], :name => "IX_LotsDesc", :unique => true

  create_table "md_dimension", :force => true do |t|
    t.string "name",   :limit => 100
    t.string "target", :limit => 45
  end

  create_table "md_group", :force => true do |t|
    t.integer "parent_id",                   :null => false
    t.integer "dimension_id",                :null => false
    t.string  "name",         :limit => 100
  end

  add_index "md_group", ["dimension_id"], :name => "IX_MdGroupDimension"

  create_table "md_group_property", :force => true do |t|
    t.integer "group_id",                       :null => false
    t.string  "name",     :limit => 100
    t.text    "content",  :limit => 2147483647
  end

  add_index "md_group_property", ["group_id"], :name => "IX_MdGroupPropertyGroup"

  create_table "md_object", :force => true do |t|
    t.integer "type_id",                :null => false
    t.string  "name",    :limit => 100
  end

  add_index "md_object", ["type_id"], :name => "IX_MdObjectType"

  create_table "md_object_property", :force => true do |t|
    t.integer "object_id",                       :null => false
    t.string  "name",      :limit => 100
    t.text    "content",   :limit => 2147483647
  end

  add_index "md_object_property", ["object_id"], :name => "IX_MdObjectPropertyObject"

  create_table "md_object_relation", :force => true do |t|
    t.integer "group_id"
    t.integer "object_id",                                  :null => false
    t.integer "object_type_id",                             :null => false
    t.integer "relation_type",  :limit => 2, :default => 1, :null => false
  end

  add_index "md_object_relation", ["group_id"], :name => "IX_MdObjectRelationGroup"
  add_index "md_object_relation", ["object_type_id"], :name => "IX_MdObjectRelationObjectType"

  create_table "md_object_right", :force => true do |t|
    t.integer "right_group_id", :null => false
    t.integer "object_id",      :null => false
    t.integer "object_type_id", :null => false
    t.integer "user_id",        :null => false
    t.integer "user_type",      :null => false
    t.boolean "permission",     :null => false
  end

  add_index "md_object_right", ["object_type_id"], :name => "IX_MdObjectRightObjectType"
  add_index "md_object_right", ["right_group_id"], :name => "IX_MdObjectRightGroup"

  create_table "md_object_type", :force => true do |t|
    t.string "name", :limit => 100, :null => false
  end

  create_table "messagessending", :primary_key => "IDPosition", :force => true do |t|
    t.integer  "IDClient",                    :null => false
    t.integer  "Type",                        :null => false
    t.datetime "Date_",                       :null => false
    t.integer  "IDMessage"
    t.integer  "notify_left", :default => -1, :null => false
  end

  create_table "messagessendingreseller", :primary_key => "IdPosition", :force => true do |t|
    t.integer  "IdReseller",                    :null => false
    t.integer  "ResellerLevel",                 :null => false
    t.datetime "Date_",                         :null => false
    t.integer  "IdMessage"
    t.integer  "notify_left",   :default => -1, :null => false
  end

  create_table "noroutes", :primary_key => "id_route", :force => true do |t|
    t.string "description", :limit => 50, :null => false
  end

  create_table "notifiestoclientslots", :id => false, :force => true do |t|
    t.integer  "IDClient",    :null => false
    t.integer  "Type",        :null => false
    t.datetime "Date",        :null => false
    t.string   "Description", :null => false
  end

  create_table "npa", :primary_key => "npa_number", :force => true do |t|
    t.string "location", :limit => 50, :default => "", :null => false
  end

  create_table "operations", :force => true do |t|
    t.integer  "type",                                             :null => false
    t.datetime "date",                                             :null => false
    t.string   "description",                                      :null => false
    t.integer  "idUser",                                           :null => false
    t.text     "xmlValue",    :limit => 2147483647
    t.integer  "client_type",                       :default => 0, :null => false
  end

  create_table "operationstypes", :force => true do |t|
    t.string "description", :limit => 50, :null => false
  end

  create_table "othergoods", :primary_key => "ID", :force => true do |t|
    t.decimal "Amount",                          :precision => 18, :scale => 2, :null => false
    t.string  "Description",     :limit => 50,                                  :null => false
    t.string  "DescriptionLong", :limit => 2000
  end

  create_table "payments", :force => true do |t|
    t.integer  "id_client",                                                     :null => false
    t.integer  "client_type",                                                   :null => false
    t.decimal  "money",        :precision => 12, :scale => 4
    t.datetime "data"
    t.integer  "type"
    t.string   "description",                                 :default => "",   :null => false
    t.integer  "invoice_id",                                  :default => 0,    :null => false
    t.decimal  "actual_value", :precision => 12, :scale => 4, :default => -1.0
    t.integer  "id_plan",                                     :default => -1
  end

  add_index "payments", ["client_type"], :name => "IX_PaymentsClientType"
  add_index "payments", ["id_client"], :name => "IX_PaymentsIDClient"

  create_table "paymentstoclientslots", :primary_key => "IDPayment", :force => true do |t|
    t.integer  "IDClient",                                    :null => false
    t.integer  "IDLot",                                       :null => false
    t.integer  "Type",                                        :null => false
    t.integer  "Interval_",                                   :null => false
    t.integer  "Period",                                      :null => false
    t.decimal  "Fee",          :precision => 18, :scale => 2, :null => false
    t.datetime "Start",                                       :null => false
    t.string   "Description_"
  end

  create_table "paymenttypes", :force => true do |t|
    t.string "name",            :limit => 40
    t.binary "show_on_invoice", :limit => 1,  :default => "b'0'", :null => false
  end

  create_table "paypal_block", :id => false, :force => true do |t|
    t.integer "block_type",                :null => false
    t.string  "argument",   :limit => 200, :null => false
  end

  create_table "paypalconfig", :id => false, :force => true do |t|
    t.integer "ClientType",                :null => false
    t.string  "Item_",      :limit => 50,  :null => false
    t.string  "Value_",     :limit => 50
    t.string  "FillTable",  :limit => 250
    t.string  "ShowColumn", :limit => 250
    t.string  "DataColumn", :limit => 250
    t.integer "IsBoolean",                 :null => false
  end

  create_table "paypalrequest", :primary_key => "TransactionID", :force => true do |t|
    t.string   "PayPalToken",       :limit => 200,                                                  :null => false
    t.string   "AuthorizationCode", :limit => 10
    t.integer  "IDClient"
    t.integer  "ClientType"
    t.integer  "OperationType"
    t.integer  "Status",                                                                            :null => false
    t.datetime "Date_"
    t.decimal  "Amount",                            :precision => 18, :scale => 2
    t.string   "ClientLogin",       :limit => 150
    t.string   "ClientPassword",    :limit => 150
    t.string   "PaymentStatus",     :limit => 150
    t.string   "SessionID",         :limit => 150
    t.string   "Buyer",             :limit => 250
    t.string   "BuyerEmail",        :limit => 50
    t.string   "BuyerAddress",      :limit => 1000
    t.integer  "MerchantID",                                                       :default => 0,   :null => false
    t.string   "BuyerCity",         :limit => 200
    t.string   "BuyerState",        :limit => 200
    t.string   "BuyerZip",          :limit => 50
    t.string   "BuyerCountry",      :limit => 100
    t.string   "BuyerLastName",     :limit => 100
    t.string   "Zone",              :limit => 50
    t.string   "Number",            :limit => 50
    t.string   "ShopData",          :limit => 2048
    t.string   "CreditCardData",    :limit => 2048
    t.string   "CreditCardInfo",    :limit => 150
    t.decimal  "ratio",                             :precision => 12, :scale => 4, :default => 1.0, :null => false
    t.integer  "id_currency",                                                      :default => 1,   :null => false
  end

  add_index "paypalrequest", ["PayPalToken", "MerchantID"], :name => "UQ_PayPalToken_MerchantID", :unique => true
  add_index "paypalrequest", ["id_currency"], :name => "IX_PayPalCurrency"

  create_table "paypalrequestgoods", :id => false, :force => true do |t|
    t.string   "PayPalToken",   :limit => 200,                                                :null => false
    t.integer  "Status",                                                                      :null => false
    t.datetime "Date_"
    t.decimal  "Amount",                        :precision => 18, :scale => 2
    t.string   "PaymentStatus", :limit => 150
    t.string   "SessionID",     :limit => 150
    t.string   "Buyer",         :limit => 250
    t.string   "BuyerEmail",    :limit => 50
    t.integer  "GoodsID",                                                                     :null => false
    t.string   "Goods",         :limit => 50
    t.string   "BuyerAddress",  :limit => 1000
    t.integer  "MerchantID",                                                   :default => 0, :null => false
    t.string   "BuyerCity",     :limit => 200
    t.string   "BuyerState",    :limit => 200
    t.string   "BuyerZip",      :limit => 50
    t.string   "BuyerCountry",  :limit => 100
    t.string   "BuyerLastName", :limit => 100
    t.string   "Zone",          :limit => 50
    t.string   "Number",        :limit => 50
  end

  create_table "pbx_companies", :primary_key => "id_company", :force => true do |t|
    t.string  "name",        :limit => 45, :null => false
    t.integer "id_reseller",               :null => false
    t.string  "dial_prefix", :limit => 45
  end

  create_table "pbx_dialingplan", :primary_key => "id_dialingplan", :force => true do |t|
    t.integer "id_company"
    t.string  "telephone_number", :limit => 45
    t.integer "priority",         :limit => 2,          :default => 0, :null => false
    t.integer "route_type",                             :default => 1, :null => false
    t.integer "id_route"
    t.string  "tech_prefix"
    t.integer "call_type"
    t.integer "from_day",         :limit => 2
    t.integer "to_day",           :limit => 2
    t.integer "from_hour",        :limit => 2
    t.integer "to_hour",          :limit => 2
    t.integer "balance_share"
    t.text    "properties",       :limit => 2147483647
  end

  create_table "pbx_inputactionscenarios", :primary_key => "id_scenario", :force => true do |t|
    t.integer "id_company",                       :null => false
    t.string  "name",       :limit => 45,         :null => false
    t.text    "properties", :limit => 2147483647
    t.text    "input_map",  :limit => 2147483647
  end

  create_table "pbx_routetypes", :primary_key => "id_routetype", :force => true do |t|
    t.string "name", :limit => 45, :null => false
  end

# Could not dump table "pbx_subaccounts" because of following ActiveRecord::StatementInvalid
#   Mysql2::Error: SHOW VIEW command denied to user 'resell'@'107-1-109-42-ip-static.hfc.comcastbusiness.net' for table 'pbx_subaccounts': SHOW CREATE TABLE `pbx_subaccounts`

  create_table "pbx_users", :primary_key => "id_user", :force => true do |t|
    t.integer "id_client"
    t.integer "id_company"
    t.integer "properties"
  end

  create_table "personalization", :force => true do |t|
    t.integer "id_client",                         :null => false
    t.integer "client_type",                       :null => false
    t.string  "module",      :limit => 45,         :null => false
    t.string  "name",        :limit => 45
    t.text    "data",        :limit => 2147483647, :null => false
  end

  create_table "pins", :primary_key => "name", :force => true do |t|
    t.integer "id_status",                                                 :null => false
    t.integer "serial",                                                    :null => false
    t.integer "id_lot",                                                    :null => false
    t.decimal "amount",    :precision => 12, :scale => 4, :default => 0.0, :null => false
  end

  add_index "pins", ["id_lot"], :name => "IX_PinsIdLot"

  create_table "pinslots", :force => true do |t|
    t.string   "name",        :limit => 50,                 :null => false
    t.datetime "dat",                                       :null => false
    t.integer  "id_currency",               :default => -1, :null => false
  end

  add_index "pinslots", ["id_currency"], :name => "IX_PlansLots_Currency"

  create_table "pinsstatus", :force => true do |t|
    t.string "name", :limit => 50, :default => "", :null => false
  end

  create_table "plans", :primary_key => "id_plan", :force => true do |t|
    t.integer  "client_type",                                                  :default => -1,                    :null => false
    t.string   "name",          :limit => 50,                                                                     :null => false
    t.string   "description",   :limit => 1024,                                                                   :null => false
    t.integer  "period",                                                       :default => -1,                    :null => false
    t.integer  "period_number",                                                :default => 1,                     :null => false
    t.integer  "id_tariffs",                                                   :default => -1,                    :null => false
    t.string   "tariffs_plans", :limit => 6000,                                                                   :null => false
    t.decimal  "amount",                        :precision => 12, :scale => 4, :default => 0.0,                   :null => false
    t.decimal  "startup_cost",                  :precision => 12, :scale => 4, :default => 0.0,                   :null => false
    t.decimal  "period_cost",                   :precision => 12, :scale => 4, :default => 0.0,                   :null => false
    t.integer  "id_reseller"
    t.integer  "type",                                                         :default => 7,                     :null => false
    t.datetime "start_time",                                                   :default => '1900-01-01 00:00:00', :null => false
    t.datetime "end_time",                                                     :default => '2049-12-31 00:00:00', :null => false
  end

  create_table "plans_packs", :primary_key => "id_plan_pack", :force => true do |t|
    t.integer  "type",                                                         :default => 7,                     :null => false
    t.integer  "client_type",                                                  :default => -1,                    :null => false
    t.integer  "id_reseller",                                                  :default => -1,                    :null => false
    t.string   "name",          :limit => 50,                                                                     :null => false
    t.string   "description",   :limit => 1024,                                                                   :null => false
    t.integer  "period",                                                       :default => -1,                    :null => false
    t.integer  "period_number",                                                :default => 1,                     :null => false
    t.string   "definition",    :limit => 2048,                                                                   :null => false
    t.integer  "id_tariffs",                                                   :default => -1,                    :null => false
    t.string   "tariffs_plans", :limit => 6000,                                                                   :null => false
    t.decimal  "amount",                        :precision => 12, :scale => 4, :default => 0.0,                   :null => false
    t.decimal  "startup_cost",                  :precision => 12, :scale => 4, :default => 0.0,                   :null => false
    t.decimal  "period_cost",                   :precision => 12, :scale => 4, :default => 0.0,                   :null => false
    t.datetime "start_time",                                                   :default => '1900-01-01 00:00:00', :null => false
    t.datetime "end_time",                                                     :default => '2049-12-31 00:00:00', :null => false
    t.integer  "id_tariff_vod",                                                :default => -1,                    :null => false
  end

  create_table "plans_packs_did_countries", :force => true do |t|
    t.integer "id_plan_pack",       :null => false
    t.integer "id_country",         :null => false
    t.integer "id_local_area_code"
  end

  add_index "plans_packs_did_countries", ["id_country"], :name => "IX_PlansPacksDidCountriesIdCountry"
  add_index "plans_packs_did_countries", ["id_local_area_code"], :name => "IX_PlansPacksDidCountriesAreaCode"
  add_index "plans_packs_did_countries", ["id_plan_pack"], :name => "IX_PlansPacksDidCountriesIdPlanPack"

  create_table "portal_clientdids", :force => true do |t|
    t.integer "country_id"
    t.string  "area_code",    :limit => 40
    t.string  "area_name",    :limit => 200
    t.string  "phone_number", :limit => 40
    t.integer "client_id"
    t.integer "client_type"
    t.integer "IDPayment",                   :default => 0,  :null => false
    t.string  "properties",   :limit => 512, :default => ""
  end

  add_index "portal_clientdids", ["phone_number"], :name => "IX_PortalClientDidsPhoneNumber"

  create_table "portal_countries", :force => true do |t|
    t.integer "country_type",                                                   :default => 0
    t.string  "country_code",      :limit => 3
    t.string  "country_name",      :limit => 40
    t.string  "country_phonecode", :limit => 4
    t.decimal "setup_fee",                       :precision => 12, :scale => 4, :default => -1.0
    t.decimal "monthly_fee",                     :precision => 12, :scale => 4, :default => -1.0
    t.string  "supplier",          :limit => 40
    t.decimal "channel_fee",                     :precision => 12, :scale => 4
  end

  create_table "portal_countries_poroperty", :force => true do |t|
    t.string  "name",       :limit => 45, :default => "", :null => false
    t.string  "value",      :limit => 45, :default => "", :null => false
    t.integer "id_country",                               :null => false
  end

# Could not dump table "portal_fax_task" because of following ActiveRecord::StatementInvalid
#   Mysql2::Error: SHOW VIEW command denied to user 'resell'@'107-1-109-42-ip-static.hfc.comcastbusiness.net' for table 'portal_fax_task': SHOW CREATE TABLE `portal_fax_task`

  create_table "portal_localareacodes", :force => true do |t|
    t.integer "country_id"
    t.string  "name",       :limit => 30
    t.string  "area_code",  :limit => 30, :default => "", :null => false
  end

  create_table "portal_localdids", :force => true do |t|
    t.integer "areacode_id"
    t.integer "availability"
    t.integer "assigned"
    t.string  "did",          :limit => 20
  end

  add_index "portal_localdids", ["areacode_id"], :name => "IX_PortalLocalDidsAreaCode"
  add_index "portal_localdids", ["did"], :name => "UQ_PortalLocalDidsDid", :unique => true

  create_table "portal_logger_blocked", :force => true do |t|
    t.datetime "block_date"
    t.string   "block_IP",   :limit => 16
  end

  create_table "portal_logger_logs", :force => true do |t|
    t.string   "login",    :limit => 30
    t.datetime "log_date"
    t.string   "log_IP",   :limit => 16
    t.integer  "status"
  end

  create_table "portal_logger_settings", :primary_key => "ref", :force => true do |t|
    t.string "val", :limit => 20
  end

  create_table "portal_toprates", :id => false, :force => true do |t|
    t.string  "id_tariff_prefix", :limit => 20
    t.integer "id_tariff"
  end

  create_table "portal_toprates_settings", :id => false, :force => true do |t|
    t.string "ref", :limit => 20
    t.string "val", :limit => 20
  end

  create_table "prefixtariff", :force => true do |t|
    t.string  "prefix",    :limit => 50,                :null => false
    t.integer "id_tariff",                              :null => false
    t.integer "type",                    :default => 0, :null => false
  end

  create_table "prefixtariffreseller", :force => true do |t|
    t.string  "prefix",         :limit => 50, :null => false
    t.integer "id_tariff",                    :null => false
    t.integer "id_reseller",                  :null => false
    t.integer "reseller_level",               :null => false
  end

  create_table "presence_policy", :force => true do |t|
    t.string  "resource",             :limit => 20, :null => false
    t.string  "watcher",              :limit => 20, :null => false
    t.boolean "permission",                         :null => false
    t.string  "vps_created_at_ip",    :limit => 33, :null => false
    t.integer "remote_listener_port", :limit => 2
  end

  create_table "presence_publications", :primary_key => "publish_id", :force => true do |t|
    t.string "resource",          :limit => 30,   :null => false
    t.string "presence_document", :limit => 1024, :null => false
  end

  create_table "properties", :primary_key => "Property", :force => true do |t|
    t.string "Value", :limit => 8000, :null => false
  end

  create_table "redirectphones", :force => true do |t|
    t.integer "id_client",                       :default => 0,  :null => false
    t.integer "client_type",                     :default => 0,  :null => false
    t.integer "call_end_reason",                 :default => 0,  :null => false
    t.string  "follow_me_number",                :default => "", :null => false
    t.integer "number_priority",  :limit => 2,   :default => 0,  :null => false
    t.string  "did_number",       :limit => 100, :default => "", :null => false
  end

  add_index "redirectphones", ["id_client", "client_type"], :name => "IX_RedirectPhones"

  create_table "registered_users", :force => true do |t|
    t.integer  "id_client",                                                         :null => false
    t.integer  "client_type",                                       :default => 32, :null => false
    t.string   "login",                               :limit => 20,                 :null => false
    t.string   "ip_address",                          :limit => 33,                 :null => false
    t.integer  "protocol",                                          :default => 1,  :null => false
    t.datetime "registration_time",                                                 :null => false
    t.integer  "id_voipswitch",                                                     :null => false
    t.string   "location_server_ip_address",          :limit => 33, :default => "", :null => false
    t.string   "internal_location_server_ip_address", :limit => 33, :default => "", :null => false
    t.integer  "ip_protocol",                                       :default => 0,  :null => false
    t.integer  "voip_protocol",                                     :default => 1,  :null => false
    t.integer  "transport_type",                                    :default => 1,  :null => false
  end

  add_index "registered_users", ["id_client"], :name => "IX_RegisteredUsersIdClient"

  create_table "reseller_settings", :force => true do |t|
    t.integer "id_reseller",                 :null => false
    t.integer "client_type",                 :null => false
    t.string  "name",                        :null => false
    t.string  "value",       :limit => 1024, :null => false
    t.string  "category",    :limit => 100,  :null => false
  end

  add_index "reseller_settings", ["id_reseller", "client_type", "name", "category"], :name => "UQ_ResellerSettings", :unique => true

# Could not dump table "resellers" because of following ActiveRecord::StatementInvalid
#   Mysql2::Error: SHOW VIEW command denied to user 'resell'@'107-1-109-42-ip-static.hfc.comcastbusiness.net' for table 'resellers': SHOW CREATE TABLE `resellers`

  create_table "resellers1", :force => true do |t|
    t.integer "idReseller"
    t.string  "login",        :limit => 20,                                                  :null => false
    t.string  "password",     :limit => 40,                                                  :null => false
    t.integer "type",                                                                        :null => false
    t.integer "id_tariff",                                                                   :null => false
    t.decimal "callsLimit",                  :precision => 12, :scale => 4, :default => 0.0, :null => false
    t.decimal "clientsLimit",                :precision => 12, :scale => 4, :default => 0.0, :null => false
    t.text    "tech_prefix",                                                                 :null => false
    t.string  "identifier",   :limit => 20,                                 :default => "",  :null => false
    t.string  "Fullname",     :limit => 200,                                :default => "",  :null => false
    t.string  "Address",      :limit => 200,                                :default => "",  :null => false
    t.string  "City",         :limit => 50,                                 :default => "",  :null => false
    t.string  "ZipCode",      :limit => 20,                                 :default => "",  :null => false
    t.string  "Country",      :limit => 50,                                 :default => "",  :null => false
    t.string  "Phone",        :limit => 50,                                 :default => "",  :null => false
    t.string  "Email",        :limit => 200,                                :default => "",  :null => false
    t.integer "MaxClients",                                                 :default => 0,   :null => false
    t.integer "template_id",                                                :default => -1,  :null => false
    t.string  "TaxID",        :limit => 50,                                 :default => "",  :null => false
    t.integer "storageLimit",                                               :default => 0,   :null => false
    t.integer "type2",                                                      :default => 0,   :null => false
    t.string  "language",     :limit => 2,                                  :default => "",  :null => false
  end

  add_index "resellers1", ["login"], :name => "UQ_Resellers1Login", :unique => true

  create_table "resellers2", :force => true do |t|
    t.integer "idReseller"
    t.string  "login",        :limit => 20,                                                  :null => false
    t.string  "password",     :limit => 40,                                                  :null => false
    t.integer "type",                                                                        :null => false
    t.integer "id_tariff",                                                                   :null => false
    t.decimal "callsLimit",                  :precision => 12, :scale => 4, :default => 0.0, :null => false
    t.decimal "clientsLimit",                :precision => 12, :scale => 4, :default => 0.0, :null => false
    t.text    "tech_prefix",                                                                 :null => false
    t.string  "identifier",   :limit => 20,                                 :default => "",  :null => false
    t.string  "Fullname",     :limit => 200,                                :default => "",  :null => false
    t.string  "Address",      :limit => 200,                                :default => "",  :null => false
    t.string  "City",         :limit => 50,                                 :default => "",  :null => false
    t.string  "ZipCode",      :limit => 20,                                 :default => "",  :null => false
    t.string  "Country",      :limit => 50,                                 :default => "",  :null => false
    t.string  "Phone",        :limit => 50,                                 :default => "",  :null => false
    t.string  "Email",        :limit => 200,                                :default => "",  :null => false
    t.integer "template_id",                                                :default => -1,  :null => false
    t.string  "TaxID",        :limit => 50,                                 :default => "",  :null => false
    t.integer "type2",                                                      :default => 0,   :null => false
    t.string  "language",     :limit => 2,                                  :default => "",  :null => false
  end

  add_index "resellers2", ["login"], :name => "UQ_Resellers2Login", :unique => true

  create_table "resellers3", :force => true do |t|
    t.string  "login",        :limit => 20,                                                  :null => false
    t.string  "password",     :limit => 40,                                                  :null => false
    t.integer "type",                                                                        :null => false
    t.integer "id_tariff",                                                                   :null => false
    t.decimal "callsLimit",                  :precision => 12, :scale => 4, :default => 0.0, :null => false
    t.decimal "clientsLimit",                :precision => 12, :scale => 4, :default => 0.0, :null => false
    t.text    "tech_prefix",                                                                 :null => false
    t.string  "identifier",   :limit => 20,                                 :default => "",  :null => false
    t.string  "Fullname",     :limit => 200,                                :default => "",  :null => false
    t.string  "Address",      :limit => 200,                                :default => "",  :null => false
    t.string  "City",         :limit => 50,                                 :default => "",  :null => false
    t.string  "ZipCode",      :limit => 20,                                 :default => "",  :null => false
    t.string  "Country",      :limit => 50,                                 :default => "",  :null => false
    t.string  "Phone",        :limit => 50,                                 :default => "",  :null => false
    t.string  "Email",        :limit => 200,                                :default => "",  :null => false
    t.string  "TaxID",        :limit => 50,                                 :default => "",  :null => false
    t.integer "type2",                                                      :default => 0,   :null => false
    t.string  "language",     :limit => 2,                                  :default => "",  :null => false
  end

  add_index "resellers3", ["login"], :name => "UQ_Resellers3Login", :unique => true

  create_table "resellerspayments", :force => true do |t|
    t.integer  "id_reseller"
    t.integer  "resellerlevel",                                :default => 0,    :null => false
    t.decimal  "money",         :precision => 12, :scale => 4
    t.datetime "data"
    t.integer  "type",                                         :default => 0,    :null => false
    t.decimal  "actual_value",  :precision => 12, :scale => 4, :default => -1.0
    t.integer  "id_plan",                                      :default => -1
    t.string   "description",                                  :default => "",   :null => false
    t.integer  "invoice_id",                                   :default => -1,   :null => false
  end

  create_table "reslottimes", :force => true do |t|
    t.integer "id_reseller",                                :default => -1,  :null => false
    t.integer "id_lot",                                     :default => -1,  :null => false
    t.decimal "multiplier",  :precision => 12, :scale => 4, :default => 1.0
  end

# Could not dump table "retailroute" because of following ActiveRecord::StatementInvalid
#   Mysql2::Error: SHOW VIEW command denied to user 'resell'@'107-1-109-42-ip-static.hfc.comcastbusiness.net' for table 'retailroute': SHOW CREATE TABLE `retailroute`

  create_table "routes", :force => true do |t|
    t.integer "routesuser_id"
    t.integer "id_route"
    t.integer "route_type"
  end

  create_table "routesusers", :force => true do |t|
    t.string  "login",       :limit => 50,                :null => false
    t.string  "password",    :limit => 50,                :null => false
    t.integer "id_route",                                 :null => false
    t.integer "route_type",                               :null => false
    t.integer "CostVisible",               :default => 1, :null => false
  end

  create_table "routetypes", :primary_key => "id_route_type", :force => true do |t|
    t.string "route_type_name", :limit => 50, :null => false
  end

  create_table "servicelog", :primary_key => "IDLog", :force => true do |t|
    t.integer  "Type",                        :null => false
    t.string   "sDescription", :limit => 500
    t.string   "sStatus",      :limit => 100
    t.datetime "Date_",                       :null => false
    t.string   "JUID",         :limit => 25
  end

  create_table "servicetoclients", :id => false, :force => true do |t|
    t.integer "IDClient", :null => false
    t.integer "Type",     :null => false
    t.integer "Months",   :null => false
    t.integer "Days",     :null => false
    t.integer "Hours",    :null => false
  end

  create_table "servicetolots", :id => false, :force => true do |t|
    t.integer "IDLot",  :null => false
    t.integer "Type",   :null => false
    t.integer "Months", :null => false
    t.integer "Days",   :null => false
    t.integer "Hours",  :null => false
  end

  create_table "settings", :force => true do |t|
    t.string "name",                                     :null => false
    t.string "value",    :limit => 1024, :default => "", :null => false
    t.string "category", :limit => 100,                  :null => false
  end

  add_index "settings", ["name", "category"], :name => "IX_SettingsNameCategory", :unique => true

  create_table "sim", :force => true do |t|
    t.string  "phone_number", :limit => 40,                :null => false
    t.integer "id_client",                  :default => 0, :null => false
    t.string  "param1",       :limit => 40,                :null => false
  end

  add_index "sim", ["phone_number"], :name => "phone_number", :unique => true

  create_table "sms_dialingplan", :primary_key => "id_dialplan", :force => true do |t|
    t.string  "telephone_number", :limit => 40,                   :null => false
    t.integer "priority",         :limit => 2,                    :null => false
    t.integer "route_type",                                       :null => false
    t.text    "tech_prefix",                                      :null => false
    t.string  "dial_as",          :limit => 40, :default => "",   :null => false
    t.integer "id_route",                                         :null => false
    t.integer "call_type",                                        :null => false
    t.integer "type",                                             :null => false
    t.integer "from_day",         :limit => 2,  :default => 0,    :null => false
    t.integer "to_day",           :limit => 2,  :default => 6,    :null => false
    t.integer "from_hour",        :limit => 2,  :default => 0,    :null => false
    t.integer "to_hour",          :limit => 2,  :default => 2400, :null => false
    t.integer "balance_share",                  :default => 100,  :null => false
  end

  create_table "sms_inbox", :primary_key => "id_sms", :force => true do |t|
    t.integer  "id_client",                                    :null => false
    t.integer  "client_type",                                  :null => false
    t.datetime "delivery_time",                                :null => false
    t.string   "from_number",   :limit => 100, :default => "", :null => false
    t.string   "to_number",     :limit => 100, :default => "", :null => false
    t.integer  "sms_status",                   :default => 0,  :null => false
    t.string   "sms_text",      :limit => 512, :default => "", :null => false
    t.string   "display_name",  :limit => 100, :default => "", :null => false
  end

  add_index "sms_inbox", ["client_type"], :name => "IX_SmsInboxClientType"
  add_index "sms_inbox", ["id_client"], :name => "IX_SmsInboxIdClient"

  create_table "sms_outbox", :primary_key => "id_sms", :force => true do |t|
    t.integer  "id_client",                                    :null => false
    t.integer  "client_type",                                  :null => false
    t.datetime "sent_time"
    t.datetime "delivery_time",                                :null => false
    t.string   "from_number",   :limit => 100, :default => "", :null => false
    t.string   "to_number",     :limit => 100, :default => "", :null => false
    t.integer  "sms_status",                   :default => 0,  :null => false
    t.string   "sms_text",      :limit => 512, :default => "", :null => false
  end

  add_index "sms_outbox", ["client_type"], :name => "IX_SmsOutboxClientType"
  add_index "sms_outbox", ["id_client"], :name => "IX_SmsOutboxIdClient"

  create_table "sms_providers", :force => true do |t|
    t.string  "name",                                                     :null => false
    t.string  "connection_string",        :limit => 1024, :default => "", :null => false
    t.integer "type",                                     :default => 0,  :null => false
    t.integer "id_tariff",                                :default => -1, :null => false
    t.string  "binary_connection_string", :limit => 1024, :default => "", :null => false
  end

  create_table "sms_providers_responses", :force => true do |t|
    t.integer "id_route",                       :null => false
    t.integer "code",                           :null => false
    t.string  "provider_string", :limit => 512
    t.string  "user_string",     :limit => 512
  end

  create_table "smsmessages", :force => true do |t|
    t.string "phone",   :limit => 50
    t.string "message", :limit => 250
  end

  create_table "smsmessagesresp", :force => true do |t|
    t.integer  "id_client",                                                                 :null => false
    t.string   "message",                                                                   :null => false
    t.string   "phone",       :limit => 50,                                                 :null => false
    t.datetime "data",                                                                      :null => false
    t.decimal  "cost",                      :precision => 12, :scale => 4, :default => 0.0, :null => false
    t.integer  "status",                                                   :default => 1,   :null => false
    t.integer  "client_type",                                              :default => 4,   :null => false
  end

# Could not dump table "tariff_to_dnis" because of following ActiveRecord::StatementInvalid
#   Mysql2::Error: SHOW VIEW command denied to user 'resell'@'107-1-109-42-ip-static.hfc.comcastbusiness.net' for table 'tariff_to_dnis': SHOW CREATE TABLE `tariff_to_dnis`

  create_table "tariffreseller", :id => false, :force => true do |t|
    t.integer "id_tariff",                    :null => false
    t.integer "id_reseller",   :default => 0, :null => false
    t.integer "resellerlevel", :default => 0, :null => false
  end

  create_table "tariffreseller_plans", :id => false, :force => true do |t|
    t.integer "id_tariff",                     :null => false
    t.integer "id_reseller",    :default => 0, :null => false
    t.integer "reseller_level", :default => 0, :null => false
  end

  create_table "tariffreseller_vod", :id => false, :force => true do |t|
    t.integer "id_tariff",                     :null => false
    t.integer "id_reseller",    :default => 0, :null => false
    t.integer "reseller_level", :default => 0, :null => false
  end

  create_table "tariffs", :primary_key => "id_tariffs_key", :force => true do |t|
    t.integer "id_tariff",                                                                        :null => false
    t.string  "prefix",           :limit => 20,                                                   :null => false
    t.string  "description",      :limit => 100,                                                  :null => false
    t.decimal "voice_rate",                      :precision => 8,  :scale => 4,                   :null => false
    t.integer "from_day",         :limit => 2,                                                    :null => false
    t.integer "to_day",           :limit => 2,                                                    :null => false
    t.integer "from_hour",        :limit => 2
    t.integer "to_hour",          :limit => 2,                                                    :null => false
    t.integer "grace_period",                                                   :default => 0,    :null => false
    t.integer "minimal_time",     :limit => 2,                                  :default => -1,   :null => false
    t.integer "resolution",       :limit => 2,                                  :default => -1,   :null => false
    t.float   "rate_multiplier",                                                :default => -1.0, :null => false
    t.float   "rate_addition",                                                  :default => -1.0, :null => false
    t.integer "surcharge_time",   :limit => 2,                                  :default => -1,   :null => false
    t.decimal "surcharge_amount",                :precision => 12, :scale => 4, :default => -1.0, :null => false
    t.string  "free_seconds",                                                   :default => "",   :null => false
  end

  add_index "tariffs", ["free_seconds"], :name => "IX_TariffsFreeSeconds"
  add_index "tariffs", ["id_tariff"], :name => "IX_TariffsIDtariff"
  add_index "tariffs", ["prefix"], :name => "IX_TariffsTariffPrefix"

  create_table "tariffs_plans", :primary_key => "id_tariffs_key", :force => true do |t|
    t.integer "id_tariff",                                                                        :null => false
    t.string  "prefix",           :limit => 20,                                                   :null => false
    t.string  "description",      :limit => 100,                                                  :null => false
    t.decimal "voice_rate",                      :precision => 8,  :scale => 4,                   :null => false
    t.integer "from_day",         :limit => 2,                                                    :null => false
    t.integer "to_day",           :limit => 2,                                                    :null => false
    t.integer "from_hour",        :limit => 2
    t.integer "to_hour",          :limit => 2,                                                    :null => false
    t.integer "grace_period",                                                   :default => 0,    :null => false
    t.integer "minimal_time",     :limit => 2,                                  :default => -1,   :null => false
    t.integer "resolution",       :limit => 2,                                  :default => -1,   :null => false
    t.float   "rate_multiplier",                                                :default => -1.0, :null => false
    t.float   "rate_addition",                                                  :default => -1.0, :null => false
    t.integer "surcharge_time",   :limit => 2,                                  :default => -1,   :null => false
    t.decimal "surcharge_amount",                :precision => 12, :scale => 4, :default => -1.0, :null => false
    t.string  "free_seconds",                                                   :default => "",   :null => false
  end

  create_table "tariffs_sms", :primary_key => "id_tariffs_key", :force => true do |t|
    t.integer "id_tariff",                                                                      :null => false
    t.string  "prefix",          :limit => 20,                                                  :null => false
    t.string  "description",     :limit => 100,                                                 :null => false
    t.decimal "voice_rate",                     :precision => 8, :scale => 4,                   :null => false
    t.integer "from_day",        :limit => 2,                                                   :null => false
    t.integer "to_day",          :limit => 2,                                                   :null => false
    t.integer "from_hour",       :limit => 2
    t.integer "to_hour",         :limit => 2,                                                   :null => false
    t.integer "grace_period",                                                 :default => 0,    :null => false
    t.integer "minimal_time",    :limit => 2,                                 :default => -1,   :null => false
    t.integer "resolution",      :limit => 2,                                 :default => -1,   :null => false
    t.float   "rate_multiplier",                                              :default => -1.0, :null => false
    t.float   "rate_addition",                                                :default => -1.0, :null => false
  end

  create_table "tariffs_vod", :primary_key => "id_tariffs_key", :force => true do |t|
    t.integer "id_tariff",                                   :null => false
    t.decimal "rate",         :precision => 12, :scale => 4, :null => false
    t.integer "rental_time",                                 :null => false
    t.integer "id_content",                                  :null => false
    t.integer "content_type",                                :null => false
  end

  add_index "tariffs_vod", ["id_tariff"], :name => "IX_TariffsVoDIdTariff"

  create_table "tariffschanges", :force => true do |t|
    t.integer  "id_tariffs_key",                                 :null => false
    t.integer  "id_tariff",                                      :null => false
    t.string   "tariffs_type",   :limit => 20,   :default => "", :null => false
    t.datetime "data",                                           :null => false
    t.integer  "used",                                           :null => false
    t.string   "action",         :limit => 20,                   :null => false
    t.string   "old_value",      :limit => 1024
    t.string   "new_value",      :limit => 1024
  end

  create_table "tariffsnames", :primary_key => "id_tariff", :force => true do |t|
    t.string   "description",               :limit => 40,                                                  :null => false
    t.integer  "minimal_time",              :limit => 2
    t.integer  "resolution",                :limit => 2
    t.integer  "surcharge_time",            :limit => 2,                                 :default => 0,    :null => false
    t.decimal  "surcharge_amount",                        :precision => 12, :scale => 4, :default => 0.0,  :null => false
    t.integer  "type",                                                                   :default => 0,    :null => false
    t.float    "rate_multiplier",                                                        :default => -1.0, :null => false
    t.float    "rate_addition",                                                          :default => -1.0, :null => false
    t.integer  "id_currency",                                                            :default => 1,    :null => false
    t.datetime "time_to_start"
    t.integer  "base_tariff_id",                                                         :default => -1,   :null => false
    t.float    "cost_threshold_resolution",                                              :default => 0.0,  :null => false
    t.float    "cost_threshold",                                                         :default => 0.0,  :null => false
  end

  create_table "tariffsnames_plans", :primary_key => "id_tariff", :force => true do |t|
    t.string   "description",               :limit => 40,                                                  :null => false
    t.integer  "minimal_time",              :limit => 2
    t.integer  "resolution",                :limit => 2
    t.integer  "surcharge_time",            :limit => 2,                                 :default => 0,    :null => false
    t.decimal  "surcharge_amount",                        :precision => 12, :scale => 4, :default => 0.0,  :null => false
    t.integer  "type",                                                                   :default => 0,    :null => false
    t.float    "rate_multiplier",                                                        :default => -1.0, :null => false
    t.float    "rate_addition",                                                          :default => -1.0, :null => false
    t.integer  "id_currency",                                                            :default => 1,    :null => false
    t.datetime "time_to_start"
    t.integer  "base_tariff_id",                                                         :default => -1,   :null => false
    t.float    "cost_threshold_resolution",                                              :default => 0.0,  :null => false
    t.float    "cost_threshold",                                                         :default => 0.0,  :null => false
  end

  create_table "tariffsnames_vod", :primary_key => "id_tariff", :force => true do |t|
    t.string  "description",         :limit => 40,                                :null => false
    t.integer "type",                                                             :null => false
    t.integer "id_currency",                                                      :null => false
    t.decimal "default_rate",                      :precision => 12, :scale => 4
    t.integer "default_rental_time"
  end

  add_index "tariffsnames_vod", ["id_currency"], :name => "IX_TariffsNamesVodCurrency"

  create_table "templates", :force => true do |t|
    t.string  "output_folder",                                                     :null => false
    t.string  "terms_of_payments"
    t.string  "invoice_item"
    t.float   "vat_rate"
    t.float   "pst_rate"
    t.string  "currency_symbol",         :limit => 5
    t.integer "decimal_places",          :limit => 2
    t.string  "invoice_number",          :limit => 100
    t.string  "place_of_making_out",     :limit => 100
    t.binary  "print_normal_template",   :limit => 1,          :default => "b'1'", :null => false
    t.string  "logo_file",               :limit => 100
    t.string  "invoice_footer",          :limit => 1024
    t.string  "seller_name",                                                       :null => false
    t.string  "seller_address",                                                    :null => false
    t.string  "tax_id",                  :limit => 45,                             :null => false
    t.integer "grouping_type",           :limit => 2
    t.binary  "send_invoice",            :limit => 1,          :default => "b'0'", :null => false
    t.binary  "create_detailed_billing", :limit => 1,          :default => "b'0'", :null => false
    t.binary  "print_call_end",          :limit => 1,          :default => "b'0'", :null => false
    t.binary  "create_summary_billing",  :limit => 1,          :default => "b'0'", :null => false
    t.binary  "reset_number_monthly",    :limit => 1,          :default => "b'0'", :null => false
    t.binary  "reset_number_yearly",     :limit => 1,          :default => "b'0'", :null => false
    t.binary  "reset_once",              :limit => 1,          :default => "b'0'", :null => false
    t.integer "number_to_reset"
    t.string  "description",             :limit => 50,                             :null => false
    t.binary  "callshop_template",       :limit => 1,                              :null => false
    t.integer "client_type",                                   :default => 64,     :null => false
    t.integer "id_client",                                     :default => -1,     :null => false
    t.text    "ext_data",                :limit => 2147483647
    t.integer "id_template_file",                              :default => -1,     :null => false
    t.text    "smtp_settings"
    t.text    "mail_content",            :limit => 2147483647
  end

  create_table "templates_countries", :force => true do |t|
    t.string  "country_iso2",  :limit => 2,   :null => false
    t.string  "country_name",                 :null => false
    t.string  "country_state", :limit => 200
    t.integer "client_type",                  :null => false
    t.integer "template_id",                  :null => false
  end

  create_table "users", :primary_key => "id_user", :force => true do |t|
    t.string  "login",                      :default => "", :null => false
    t.string  "password",    :limit => 128, :default => "", :null => false
    t.string  "fullname",                   :default => "", :null => false
    t.string  "address",                    :default => "", :null => false
    t.string  "city",                       :default => "", :null => false
    t.string  "zipcode",                    :default => "", :null => false
    t.string  "country",                    :default => "", :null => false
    t.string  "phone",                      :default => "", :null => false
    t.string  "email",                      :default => "", :null => false
    t.integer "type",                       :default => 0,  :null => false
    t.integer "id_client",                  :default => -1, :null => false
    t.integer "client_type",                :default => -1, :null => false
  end

  add_index "users", ["client_type"], :name => "IX_UsersClientType"
  add_index "users", ["id_client"], :name => "IX_UsersClientId"
  add_index "users", ["login"], :name => "IX_UsersLogins", :unique => true

  create_table "users_permissions", :primary_key => "id_permission", :force => true do |t|
    t.integer "id_user",                :null => false
    t.string  "command",                :null => false
    t.boolean "enabled",                :null => false
    t.integer "type",    :default => 0, :null => false
  end

  add_index "users_permissions", ["id_user", "command"], :name => "UserCommand", :unique => true

  create_table "video_codecs", :force => true do |t|
    t.integer "id_codec"
    t.string  "description",          :limit => 20,  :default => "", :null => false
    t.integer "payload_type",                                        :null => false
    t.string  "sip_rtpmap",           :limit => 100,                 :null => false
    t.string  "sip_codec_string",     :limit => 100,                 :null => false
    t.string  "sip_codec_parameter",  :limit => 100,                 :null => false
    t.integer "voipbox_payload_size",                                :null => false
    t.string  "voipbox_file_suffix",  :limit => 20,                  :null => false
    t.integer "voipbox_wait",                        :default => 0,  :null => false
    t.integer "voipbox_time_step",                   :default => 0,  :null => false
    t.integer "wave_file_format",                    :default => 0,  :null => false
    t.float   "ms_per_byte",                                         :null => false
    t.string  "sdp_parameters",       :limit => 500,                 :null => false
    t.integer "codec_type",                          :default => 0,  :null => false
  end

  add_index "video_codecs", ["id_codec"], :name => "UQ_VideoCodecsIdCodec", :unique => true

  create_table "voicemailusers", :force => true do |t|
    t.integer "id_client",                     :null => false
    t.integer "client_type",                   :null => false
    t.string  "email",         :default => "", :null => false
    t.string  "start_message", :default => "", :null => false
  end

  add_index "voicemailusers", ["id_client", "client_type"], :name => "IX_voicemailusersClientType"

  create_table "voicemessages", :force => true do |t|
    t.integer  "id_client",                                    :null => false
    t.integer  "client_type",                                  :null => false
    t.datetime "message_start",                                :null => false
    t.integer  "duration",                                     :null => false
    t.integer  "message_type",                 :default => 0,  :null => false
    t.string   "caller_ani",    :limit => 40,  :default => "", :null => false
    t.string   "filename",                     :default => "", :null => false
    t.integer  "id_message",                   :default => 0,  :null => false
    t.integer  "remind_send",                  :default => 0
    t.text     "message_text"
    t.string   "display_name",  :limit => 100, :default => "", :null => false
  end

  add_index "voicemessages", ["id_client", "client_type"], :name => "IX_VoiceMessagesClientType"

  create_table "voipbox", :force => true do |t|
    t.string "description", :limit => 50, :null => false
  end

  create_table "voipbox_history", :force => true do |t|
    t.string   "version", :limit => 100, :null => false
    t.datetime "start",                  :null => false
    t.datetime "stop",                   :null => false
  end

  create_table "voipbox_routes", :force => true do |t|
    t.integer "id_route",                  :default => 0,  :null => false
    t.string  "description", :limit => 20, :default => "", :null => false
    t.string  "ip_number",   :limit => 23, :default => "", :null => false
    t.integer "type",                      :default => 0,  :null => false
    t.text    "xml_config"
  end

  create_table "webpaymentoperations", :primary_key => "ID", :force => true do |t|
    t.string   "Description", :limit => 250, :null => false
    t.string   "SessionID",   :limit => 150
    t.datetime "Date_",                      :null => false
  end

  create_table "zone_numbers", :primary_key => "id_number", :force => true do |t|
    t.string   "login",            :limit => 20, :null => false
    t.string   "password",         :limit => 20
    t.datetime "reservation_date"
    t.integer  "status"
    t.integer  "id_zone",                        :null => false
  end

  add_index "zone_numbers", ["id_zone"], :name => "IX_id_zone"

  create_table "zonefiles", :id => false, :force => true do |t|
    t.integer "ClientType",                 :null => false
    t.string  "Zone",        :limit => 50,  :null => false
    t.string  "File_",       :limit => 500, :null => false
    t.string  "Description"
  end

  create_table "zones", :primary_key => "id_zone", :force => true do |t|
    t.integer "client_type",                :null => false
    t.string  "name",        :limit => 100, :null => false
    t.string  "description", :limit => 250
  end

end
