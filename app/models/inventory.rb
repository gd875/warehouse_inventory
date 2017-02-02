class Inventory < ActiveRecord::Base
    has_many :products
    has_many :transfers
    belongs_to :user
end