module WorksHelper

  #
  # is this a published work?
  #
  def is_published( work )
    return false if work['status'].nil?
    return work['status'] == 'submitted'
  end

  #
  # if we get a date with timezone identification, convert to local time
  #
  def localize_date_string( date )
    return '' if date.blank?
    begin
       dt = Time.zone.parse( date )
       return dt.strftime( '%Y-%m-%d %H:%M:%S' )
    rescue => e
    end
    return date
  end
end
