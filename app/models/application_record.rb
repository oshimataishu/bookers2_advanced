class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :latest, -> { order(created_at: :desc)}
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day...Time.zone.now.end_of_day) }
  scope :created_last_week, -> { where(created_at: 14.day.ago.beginning_of_day...7.day.ago.end_of_day) }
end
