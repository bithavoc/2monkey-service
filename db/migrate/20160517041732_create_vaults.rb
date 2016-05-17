class CreateVaults < ActiveRecord::Migration
  def change
    create_table :vaults do |t|
      t.string :name, unique: true
      t.string :password
      t.string :token

      t.timestamps null: false
    end

    add_index :vaults, [:name, :password], unique: true
    add_index :vaults, [:token], unique: true
  end
end
