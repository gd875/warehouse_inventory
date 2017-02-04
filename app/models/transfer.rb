class Transfer < ActiveRecord::Base
    has_many :inventories
    has_many :warehouses
    belongs_to :user
    validates :product_id, presence: true
    validates :name, presence: true
    validates :customer_id, presence: true
    validates :quantity, presence: true
end