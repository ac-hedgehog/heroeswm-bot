module GameUsersHelper
  DEFAULT_TIME_INTERVAL = 8.hours
  DEFAULT_LAST_END_TIME = Time.new.change(hour: 23, min: 30)
  
  def time_for_select(time)
    time.change(hour: time.hour, min: time.min - time.min % 10)
  end
  
  def start_time_for_select
    time_for_select(Time.now)
  end
  
  def end_time_for_select
    if Time.now.hour < (Time.now + DEFAULT_TIME_INTERVAL).hour
      time_for_select(Time.now + DEFAULT_TIME_INTERVAL)
    else
      time_for_select(DEFAULT_LAST_END_TIME)
    end
  end
end
