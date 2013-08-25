class CreateScreenshots < ActiveRecord::Migration
  def change
    create_table :screenshots do |t|
      t.text :url
      t.integer :status
      t.binary :image
      t.timestamp :captured_at
      t.timestamp :accessed_at

      t.timestamps
    end
    add_index :screenshots, :url, unique: true
    add_index :screenshots, :status
  end
end
