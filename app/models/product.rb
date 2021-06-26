class Product < ApplicationRecord

    #save
    before_save :validate_product
    after_save :send_notification
    after_save :push_notification, if: :discount? # si el metodo discount? = true, callback se ejecuta

    validates :title, presence: {message: "Es necesario el titulo"} # cambiar el mensaje, presence = true default
    validates :code, uniqueness: {message: "El code: %{value} esta en uso"} # response, %{valor del atributo}
    
    # validates :price, length: {minimum:3, maximum:5} 
    #Validate with condional same before
    validates :price, length: {in: 3..5, message:"El precio esta fuera de rango"}, if: :has_price?
    # si el methodo has_price return true, se ejecuta la validacion, en caso contrario se ignora
    validate :code_validate
    validates_with ProductValidator # Que ejecute el metodo validate pasando como argumento el objeto que se 
    #pretende persistir 

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
