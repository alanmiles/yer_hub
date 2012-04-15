module AbscatsHelper

  def approve_text
    if @abscat.approved?
      return "Approved"
    else
      return "Approval pending"
    end
  end
end
