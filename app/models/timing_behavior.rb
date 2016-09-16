class Time
	def to_ms
		(self.to_f * 1000.0).to_i
	end
end

class TimingBehavior

	attr_accessor :what
	attr_accessor :start_time

	def initialize( what = nil )
		@what = what
		return self
	end

	def start
     @start_time = Time.now
		 return self
	end

	def log_completed( other = nil )
		Rails.logger.info "TIMED: #{@what} took #{elapsed}mS #{other}"
	end

	private

	def elapsed
		return Time.now.to_ms - @start_time.to_ms
	end

end
