class Recipe < ApplicationRecord
    has_many :meals, dependent: :destroy
    validates :title, presence: true, uniqueness: true
    has_one_attached :picture

    def valid_with_picture? (picture)
        val = valid?
        if picture.nil?
            return val
        end
        if  picture.size < 1.kilobyte
            errors.add(:picture, "is too small (<1Kb)")
        end
        if picture.size > 2.megabytes
            errors.add(:picture, "is too big (>2Mb)")
        end
        unless picture.content_type.in?(valid_mimes)
            errors.add(:picture, "has unknown file format")
        end
        return !errors.include?(:picture) && val
    end

    def title=(value)
        self[:title] = value.squish
    end
    
    def valid_mimes
        %w(image/jpeg image/jpg image/png image/webp image/gif image/tiff image/x-tiff image/fif image/bmp image/x-windows-bmp)
    end
    def self.extensions
        {
            'image/jpeg' => '.jpeg',
            'image/jpg' => '.jpg',
            'image/png' => '.png',
            'image/webp' => '.webp',
            'image/gif' => '.gif',
            'image/tiff' => '.tiff',
            'image/x-tiff' => '.tiff',
            'image/fif' => '.fif',
            'image/bmp' => '.bmp',
            'image/x-windows-bmp' => '.bmp',
        }
    end
end
