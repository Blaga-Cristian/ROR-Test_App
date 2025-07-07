class UserEntry < ApplicationRecord
  belongs_to :user

  default_scope -> { order(date: :desc) }

  validates   :user_id, presence: true
  validates   :date, presence: true
  validates   :time, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates   :distance, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def format_distance
    if distance > 1000 
      "#{(distance / 1000.0).round(1)}km"
    else
      "#{distance}m"
    end
  end

  def format_time
    hours = time / 60
    minutes = time % 60
   
    if hours > 0 && minutes > 0
      "#{hours}h #{minutes}m"
    elsif hours > 0
      "#{hours}h"
    elsif minutes > 0
      "#{minutes}m"
    else
      "N/A"
    end

  end

  def format_date
    date.strftime("%H:%M · %b %-d, %Y")
  end

  def average_speed
    ((distance / 1000.0) / (time / 60.0)).round(1)  
  end

  def format_average_speed
    "#{average_speed}km/h"
  end

end

