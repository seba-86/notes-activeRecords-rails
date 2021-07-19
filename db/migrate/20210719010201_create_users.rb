class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username, :null => false #restriccion directa a db
      t.string :email

      t.timestamps
    end
  end
end
