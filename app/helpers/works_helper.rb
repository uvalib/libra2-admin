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

  #
  # create label to indicate what type of work this is
  #
  def work_label( work_source )
    return '<span class="label label-warning">O</span>' if work_source.start_with? 'optional'
    return '<span class="label label-info">S</span>' if work_source.start_with? 'sis'
    return '<span class="label label-success">I</span>' if work_source.start_with? 'ingest'
    return '<span class="label label-primary">L</span>' if work_source.start_with? 'libra-oa'
    return ''
  end

end
