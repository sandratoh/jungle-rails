class Sale < ActiveRecord::Base

  validates :name, presence: true
  validates :percent_off, presence: true, 
                          numericality: { greater_than: 0 }
  validates :starts_on, presence: true
  validates :ends_on, presence: true
  validate :end_date_must_be_later_than_start_date

  # Custom Validation
  def end_date_must_be_later_than_start_date
    unless ends_on.nil? && starts_on.nil?
      if ends_on < starts_on
        errors.add(:ends_on, "must be later than Starts on")
      end
    end
  end

  # AR Scope
  def self.active
    where("sales.starts_on <= ? AND sales.ends_on >= ?", Date.current, Date.current)
  end

  # Alternate way of writing AR Scope
  # scope :active, -> { where("sales.starts_on <= ? AND sales.ends_on >= ?", Date.current, Date.current) }

  def finished?
    ends_on < Date.current
  end

  def upcoming?
    starts_on > Date.current
  end

  def active?
    !upcoming? && !finished?
  end
end
