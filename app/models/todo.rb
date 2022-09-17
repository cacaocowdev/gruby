class Todo < ApplicationRecord
    validates :title, presence: true
    validates :due, presence: true

    def title=(value)
        self[:title] = value.squish
    end
end
