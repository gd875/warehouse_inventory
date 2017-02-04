class Product < ActiveRecord::Base
    has_many :inventory
    belongs_to :user
    validates :name, presence: true
    validates :each_in_case, presence: true
    validates :cases_in_layer, presence: true
    validates :layers_in_pallet, presence: true
end