class Transaction < ApplicationRecord
    validates :category, presence: true
    validates :use, presence: true
    validates :date, presence: true
    validates :amount, presence: true

    def amount_fmt
        if amount.nil? 
            return '0.00'
        else
            return '%.02f' % (amount / 100.0)
        end
    end
end
