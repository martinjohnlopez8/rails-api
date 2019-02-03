class Timeclock < ApplicationRecord
	serialize :epoch_time, Array
	validates :device_id, uniqueness: true
end
