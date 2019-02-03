require 'date'
require "time"

class TimeclockController < ApplicationController
	def create
		timeclock = Timeclock.find_by(device_id: params[:device_id])
		
		if timeclock.present?
			timeclock.epoch_time.push(params[:epoch_time])
			timeclock.save()
			render json: {data: timeclock},status: :ok
		else
			timeclock = Timeclock.new(device_id: params[:device_id], epoch_time: [params[:epoch_time]])
			if timeclock.save
				render json: {data: timeclock},status: :ok
			else
				render json: {data: timeclock.errors},status: :unprocessable_entity
			end
		end
	end

	def date_valid?(date)
	  format = '%Y-%m-%d'
	  DateTime.strptime(date, format)
	  true
	rescue ArgumentError
	  false
	end

	def get_devices_date
		if date_valid?(params[:date])
			date_time = DateTime.strptime(params[:date],'%Y-%m-%d').to_date
		else
			date_time = DateTime.strptime(params[:date],'%s').to_date
		end

		timeclocks = Timeclock.where(device_id: params[:device_id])
		epoch_time = []
		for timeclock in timeclocks
			for time_obj in timeclock.epoch_time
				if DateTime.strptime(time_obj,'%s').to_date == date_time
					epoch_time.push(time_obj)
				end
			end
		end

		if timeclocks.present?
			render json: {data: epoch_time},status: :ok
		end
	end

	def get_all_date
		if date_valid?(params[:date])
			date_time = DateTime.strptime(params[:date],'%Y-%m-%d').to_date
		else
			date_time = DateTime.strptime(params[:date],'%s').to_date
		end

		device_obj = Hash.new
		timeclocks = Timeclock.all
		for timeclock in timeclocks
			epoch_list = []
			device_obj[timeclock.device_id] = epoch_list
			for epoch in timeclock.epoch_time
				if DateTime.strptime(epoch,'%s').to_date == date_time
					epoch_list.push(epoch)
				end
			end
		end
		render json: device_obj,status: :ok
	end

	def get_devices_from_to
		if date_valid?(params[:from])
			date_from = DateTime.strptime(params[:from],'%Y-%m-%d').to_date
		else
			date_from = DateTime.strptime(params[:from],'%s')
		end

		if date_valid?(params[:to])
			date_to = DateTime.strptime(params[:to],'%Y-%m-%d').to_date
		else
			date_to = DateTime.strptime((params[:to].to_i - 1).to_s, '%s')
		end

		puts (params[:to].to_i - 1)
		timeclocks = Timeclock.where(device_id: params[:device_id])
		epoch_time = []
		for timeclock in timeclocks
			for time_obj in timeclock.epoch_time
				epoch = DateTime.strptime(time_obj,'%s')
				if epoch >= date_from and epoch <= date_to
					epoch_time.push(time_obj)
				end
			end
		end

		render json: epoch_time, status: :ok
	end

	def get_all_from_to
		if date_valid?(params[:from])
			date_from = DateTime.strptime(params[:from],'%Y-%m-%d').to_date
		else
			date_from = DateTime.strptime(params[:from],'%s')
		end

		if date_valid?(params[:to])
			date_to = DateTime.strptime(params[:to],'%Y-%m-%d').to_date
		else
			date_to = DateTime.strptime((params[:to].to_i - 1).to_s, '%s')
		end

		device_obj = Hash.new
		timeclocks = Timeclock.all
		for timeclock in timeclocks
			epoch_list = []
			device_obj[timeclock.device_id] = epoch_list
			for epoch in timeclock.epoch_time
				epoch_new = DateTime.strptime(epoch,'%s')
				if epoch_new >= date_from and epoch_new <= date_to
					epoch_list.push(epoch)
				end
			end
		end

		render json: device_obj,status: :ok
	end

	def clear
		timeclocks = Timeclock.delete_all
		return render json: {message: 'success'}, status: :ok
	end

	def device_list
		return render :json => Timeclock.all.each.map(&:device_id)
		
	end
end
