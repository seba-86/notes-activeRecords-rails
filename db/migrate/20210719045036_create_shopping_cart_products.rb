class CreateShoppingCartProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :shopping_cart_products do |t|
      t.references :product, null: false, foreign_key: true
      t.references :shopping_cart, null: false, foreign_key: true

      t.timestamps
    end
  end
end
