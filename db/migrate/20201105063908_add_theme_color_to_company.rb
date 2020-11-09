class AddThemeColorToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :theme_color, :string
    add_column :companies, :css, :string
  end
end
