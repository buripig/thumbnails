class AddErrorInfoToScreenshots < ActiveRecord::Migration
  def change
    add_column :screenshots, :error_info, :text
  end
end
