class User < ApplicationRecord
    has_many :shopping_carts # = ShoppingCart model
    has_one :shopping_cart, -> { where(active:true).order('id DESC')} #funcion anonima = condicion:
    # sobre el listado de carts que posee el user (has_many :shopping_carts), return cart active = true en orden descendente
    #osea retorna el ultimo por id que esta activo (el mas actual) que cumpla con la condicion.
end
