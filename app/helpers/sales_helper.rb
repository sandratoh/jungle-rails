module SalesHelper

  def active_sale?
    Sale.active.any?
  end

  def current_sale
    Sale.find_by("starts_on <= ? AND ends_on >= ?", Date.current, Date.current)
  end
end