class CreateArtists < ActiveRecord::Migration[5.2]
  def change
    create_table :artists do |t|
      t.string :artist
      t.string :genre

      t.timestamps
    end
  end
end