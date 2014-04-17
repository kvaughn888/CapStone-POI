class CreatePois < ActiveRecord::Migration
  def change
    create_table :pois do |t|
      t.float :latitude
      t.float :longitude
      t.string :address
      t.string :description
      t.string :title
	  t.integer :user_id
	  t.string :sponsor
	  t.integer :total_ratings
	  t.integer :total_people
	  t.integer :avg_rating

      t.timestamps
    end
  end
end
