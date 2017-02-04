class Inventory < ActiveRecord::Base
    has_many :products
    has_many :transfers
    belongs_to :user
    validates :product_id, presence: true
    validates :pallet_count, presence: true

end