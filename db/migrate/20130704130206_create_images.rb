class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :title
      t.string :origin
      t.string :imagetype
      t.string :local
      t.string :fileid
      t.string :category
      t.decimal :geo_lat
      t.decimal :geo_lng
      t.date :date_start
      t.date :date_end
      t.text :description
      t.string :path_to_image

      t.timestamps
    end
  end
end
