Rails.application.routes.draw do
	get '/devices' => 'timeclock#device_list'
	get '/all/:date' => 'timeclock#get_all_date'
	get '/all/:from/:to' => 'timeclock#get_all_from_to'
	get '/:device_id/:date' => 'timeclock#get_devices_date'
	get '/:device_id/:from/:to' => 'timeclock#get_devices_from_to'
	post '/:device_id/:epoch_time' => 'timeclock#create'
	post '/clear_data' => 'timeclock#clear'
end
