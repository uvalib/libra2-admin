module WorksHelper

  def formatted_date( date )
     return '' if date.blank?
     if match = date.match( /^(\d{4}-\d{2}-\d{2}).*$/ )
        return match.captures[ 0 ]
     end
     return ''
  end

end
