class Warehouse < ActiveRecord::Base
    has_many :inventory
    belongs_to :user
end