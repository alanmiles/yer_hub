module CurrenciesHelper

  def approval_text
    if @currency.approved?
      return "Approved"
    else
      return "Approval pending"
    end
  end
end
