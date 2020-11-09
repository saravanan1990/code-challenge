class Company < ApplicationRecord
  has_rich_text :description
  validates :email, format: { with: /\b[A-Z0-9._%a-z\-]+@getmainstreet\.com\z/,
                  message: "must be a getmainstreet.com account" }, :if => :email?

end
