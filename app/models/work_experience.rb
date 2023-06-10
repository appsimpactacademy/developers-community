class WorkExperience < ApplicationRecord
  belongs_to :user

  validates :company, :start_date, :employment_type, :job_title,
            :location, :location_type, presence: true

  validate :work_experience_last_date
  validate :presence_of_end_date
  validate :end_date_greater_than_start_date, if: :currently_not_working_here?

  def work_experience_last_date
    if end_date.present? && currently_working_here
      errors.add(:end_date, ' must be blank if you are currently working in this company')
    end
  end

  def presence_of_end_date
    if end_date.nil? && !currently_working_here
      errors.add(:end_date, ' must be present if you are not currently working in this company')
    end
  end

  def currently_not_working_here?
    !currently_working_here
  end

  def end_date_greater_than_start_date
    return if end_date.nil?

    if end_date < start_date
      errors.add(:end_date, ' must be greater than start_date')
    end
  end
end
