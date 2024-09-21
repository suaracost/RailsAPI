class CreatePersonaWrites < ActiveRecord::Migration[7.2]
  def change
    create_table :persona_writes do |t|
      t.string :cedula
      t.string :nombre

      t.timestamps
    end
  end
end
