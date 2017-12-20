module WorksHelper

  #
  # is this a published work?
  #
  def is_published( work )
    return false if work['status'].nil?
    return work['status'] == 'submitted'
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
