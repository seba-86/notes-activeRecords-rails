class ProductValidator < ActiveModel::Validator
    # Validaciones atravez de clases 
    # sobrescribir el metodo validate, obligatorio
    
    def validate(record)# x convencion 'record'
        self.validate_stock(record)
    end

    def validate_stock(record)
        if record.stock < 0
            record.errors.add(:stock, "El stock no puede ser negativo")
        end
    end

    

end