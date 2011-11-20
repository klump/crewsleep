class UpcCode

	def initialize(code)
		@code = code
	end

	def to_i
		return @code[0..-2].to_i
	end

end