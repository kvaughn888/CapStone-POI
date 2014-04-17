class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :subject
      t.text :body
      t.string :sender
      t.string :recipient
      t.boolean :has_read

      t.timestamps
    end
  end
end
