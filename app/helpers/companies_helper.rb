module CompaniesHelper

	def get_city_and_state(company)
		city_and_state = ""
  	city_and_state = "<mark>" if !company.city.blank? || !company.state.blank?
  	city_and_state += "#{company.city}"
  	city_and_state += "," if !city_and_state.blank? && !company.state.blank?
  	city_and_state += "#{company.state}"
  	city_and_state += "</mark>" if !city_and_state.blank?
  	city_and_state.html_safe
  end 

end
