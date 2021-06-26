class Product < ApplicationRecord

    #save
    before_save :validate_product
    after_save :send_notification
    after_save :push_notification, if: :discount? # si el metodo discount? = true, callback se ejecuta

    def total
        self.price / 100
    end

    def discount?
        self.total < 5
    end

    private
    
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
