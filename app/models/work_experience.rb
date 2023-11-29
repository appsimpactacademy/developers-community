# frozen_string_literal: true

class WorkExperience < ApplicationRecord
  EMPLOYMENT_TYPE = %w[Full-time Part-time Self-employeed Freelance Trainee Internship].freeze
  LOCATION_TYPE = %w[On-site Hybrid Remote].freeze
  belongs_to :user

  validates :company, :start_date, :job_title, :location, presence: true
  validates :employment_type, presence: true, inclusion: { in: EMPLOYMENT_TYPE, message: 'not a valid employment type' }
  validates :location_type, presence: true, inclusion: { in: LOCATION_TYPE, message: 'not a valid location type' }

  validate :work_experience_last_date
  validate :presence_of_end_date
  validate :end_date_greater_than_start_date, if: :currently_not_working_here?

  def work_experience_last_date
    return unless end_date.present? && currently_working_here

    errors.add(:end_date, ' must be blank if you are currently working in this company')
  end

  def presence_of_end_date
    return unless end_date.nil? && !currently_working_here

    errors.add(:end_date, ' must be present if you are not currently working in this company')
  end

  def currently_not_working_here?
    !currently_working_here
  end

  def end_date_greater_than_start_date
    return if end_date.nil? || start_date.nil?

    return unless end_date < start_date

    errors.add(:end_date, ' must be greater than start_date')
  end

  def company_with_employment_type
    "#{company} (#{employment_type})".strip
  end

  def job_location
    "#{location} (#{location_type})"
  end

  def job_duration
    months = if end_date.present?
               fetch_months(end_date)
             else
               fetch_months(Date.today)
             end

    result = months.divmod(12)

    duration = "#{result.first} #{result.first > 1 ? 'years' : 'year'} #{result.last} #{result.last > 1 ? 'months' : 'month'}"
    if currently_working_here
      "#{start_date.strftime('%b %Y')} - Present (#{duration})"
    else
      "#{start_date.strftime('%b %Y')} - #{end_date.strftime('%b %Y')} (#{duration})"
    end
  end

  private

  def fetch_months(last_date)
    ((last_date.year - start_date.year) * 12 + last_date.month - start_date.month - (last_date.day >= start_date.day ? 0 : 1)).round
  end
end
