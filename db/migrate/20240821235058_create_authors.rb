class CreateAuthors < ActiveRecord::Migration[7.2]
  def change
    create_table :authors do |t|
      t.string :name, index: true

      t.timestamps
    end
  end
end
