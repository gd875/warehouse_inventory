class Warehouse < ActiveRecord::Base
    has_many :inventory
    belongs_to :user
    validates :name, presence: true
    validates :location, presence: true
end