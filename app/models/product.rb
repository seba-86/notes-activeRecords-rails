class Product < ApplicationRecord

    #save
    before_save :validate_product
    after_save :send_notification
    after_save :push_notification, if: :discount? # si el metodo discount? = true, callback se ejecuta

    validates :title, presence: {message: "Es necesario el titulo"} # cambiar el mensaje, presence = true default
    validates :code, uniqueness: {message: "El code: %{value} esta en uso"} # response, %{valor del atributo}
    
    # validates :price, length: {minimum:3, maximum:5} 
    #Validate with condional same before
    validates :price, length: {in: 3..5, message:"El precio esta fuera de rango"}, if: :has_price? #condicionar la validacion de length
    # si el methodo has_price return true, se ejecuta la validacion, en caso contrario se ignora
    validate :code_validate #Lo mismo que validates price pero personalizada con un metodo (code_validate)
    validates_with ProductValidator # Que ejecute el metodo validate pasando como argumento el objeto que se 
    #pretende persistir 

    #scopes = consulta pre establecida para el modelo
    #scope 1:
                # scope :available, -> { where("stock >= ?", 1)} #funcion anonima = ej: { where(:attibute => value)} 
    scope :available, -> (min=1) { where("stock >=?", min)} # scope con argumentos
    
    # Todos los products que el stock sea mayor o igual a 1
    # result: Product Load (0.4ms)  SELECT "products".* FROM "products" WHERE (stock >= 1) /* loading for inspect */ LIMIT ?  [["LIMIT", 11]]

    #(available se registra como metodo de clase = Product.available), se podria utilizar el metodo pasandole el argumento directamente
    #  ej: Product.available(20) = Products con stock que sean mayor a 20

    #scope 2:

    scope :order_price_desc, -> { order("price DESC")} # Ordenar los productos en orden desc en relacion al precio 
    #result :  Product Load (0.4ms)  SELECT "products".* FROM "products" /* loading for inspect */ ORDER BY price DESC LIMIT ?  [["LIMIT", 11]]
    
    # Concatenar scopes, 
    #eJ: Obtener todos los productos cuyo stock sea mayor o igual a 10 y posterior ordenarlos con respecto al precio
    # de forma descendente = Product.available(10).order_price_desc
    # result: SELECT "products".* FROM "products" WHERE (stock >=10) /* loading for inspect */ ORDER BY price DESC LIMIT ?  [["LIMIT", 11]]

    scope :available_and_order_price_desc, -> { available.order_price_desc}
   #scope 1 + scope 2
   #Product.available_and_order_price_desc
   #result: Product Load (0.4ms)  SELECT "products".* FROM "products" WHERE (stock >=1) /* loading for inspect */ ORDER BY price DESC LIMIT ?  [["LIMIT", 11]]

    #used validation
    # var with valid?
    # var with persisted?
    # var with error.messages

    def total
        self.price / 100
    end

    def discount?
        self.total < 5
    end
    #example if product free
    def has_price?
        !self.price.nil? && self.price > 0 # si el producto tiene un precio y es mayor a 0 (response: true or false)
    end

    #utilizar scopes por medio de metodo de clase
    # titulo y codigo de los 5 productos mas caros =
    def self.top_5_expensive #self para convertirlo en metodo de clase del modelo 
        self.available.order_price_desc.limit(5).select(:title, :code) #select 
        #Condicionar, ordenar, limitar y seleccion de atributos
    end


    private

    def code_validate
        # Add new errors with method add = "Agregar un nuevo error"
        # Add conditional
        #Primer atributo si cumpple con la condicion (:code)
        if self.code.nil? || self.code.length < 3 # si el codigo es nulo or code tiene una longitud menor a 3 , if true = add.errors
            self.errors.add(:code, "El code debe poseer 3 caracteres")
        end
    end

    def validate_product
        puts "\n\n>>> Un nuevo producto sera añdidp a almacen!"
    end

    def send_notification
        puts "\n\n>>> Un nuevo producto fue añadido a almacen: #{self.title} - $#{self.total} USD"
    end
    #SI UN PRICE < 5 USD, EL CALLBACK SE EJECUTA
    def push_notification

        puts "\n\n >>> Un nuevo producto ya se encuentra en descuento #{self.title}"
    end



end
