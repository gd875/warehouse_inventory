class Transfer < ActiveRecord::Base
    has_many :inventories
    has_many :warehouses
    belongs_to :user
end