class Company < ApplicationRecord
  has_rich_text :description
  validates :email, format: { with: /\b[A-Z0-9._%a-z\-]+@getmainstreet\.com\z/,
                  message: "must be a getmainstreet.com account" }, :if => :email?
  before_save :update_city_and_state, if: :zip_code?
  mount_uploader :css, CssUploader

  def update_city_and_state
  	zip_code_hash = ZipCodes.identify(zip_code)
    self.city = zip_code_hash.blank? ? "" : zip_code_hash[:city]
    self.state = zip_code_hash.blank? ? "" : zip_code_hash[:state_name]
  end

end
