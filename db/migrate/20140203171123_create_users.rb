class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
	  t.string :roles
	  t.string :provider
	  t.string :uid
	  t.string :address1
	  t.string :address2
	  t.string :city
	  t.string :state
	  t.integer :zip
	  t.integer :phone1
	  t.integer :phone2
	  t.integer :phone3
	  t.integer :age
	  t.string :sex
	  t.string :bio
	  t.string :website
	  t.string :remember_me
	  t.string :password_reset_token
	  t.datetime :password_expires_after
	  t.string :salt
	  t.boolean :is_approved

      t.timestamps
    end
  end
end
