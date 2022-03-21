class Transaction < ApplicationRecord
    validates :category, presence: true
    validates :use, presence: true
    validates :date, presence: true
    validates :amount, presence: true
end
