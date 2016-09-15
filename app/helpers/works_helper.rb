module WorksHelper

  def formatted_date( date )
     return '' if date.blank?
     d = ''
     t = ''
     if match = date.match( /^(\d{4}-\d{2}-\d{2}).*$/ )
        d = match.captures[ 0 ]
     end

     if match = date.match( /(\d{2}:\d{2}:\d{2}).*$/ )
       t = match.captures[ 0 ]
     end

     return "#{d} #{t}"
  end

end
