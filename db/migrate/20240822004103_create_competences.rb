class CreateCompetences < ActiveRecord::Migration[7.2]
  def change
    create_table :competences do |t|
      t.string :name, index: { unique: true }

      t.timestamps
    end
  end
end
