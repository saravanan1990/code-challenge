module Services
	class ColorGenerator
		attr_accessor :company

		def initialize(company)
			self.company = company
		end

		def get_color_scheme
			company.theme_color = "#FFFFFF"
			return company
		end
	end
end