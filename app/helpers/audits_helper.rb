module AuditsHelper

  #
  # is this a published work?
  #
  def viewable_audit_line( audit )
    return '' if audit.blank?
    return audit.gsub( '\\r\\n', ', ').gsub( '\\n', ', ')
  end

end
