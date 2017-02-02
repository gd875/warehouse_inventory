class Customer < ActiveRecord::Base
    has_many :transfers
    has_many :inventory, through: :transfers
    belongs_to :user
end