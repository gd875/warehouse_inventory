class Customer < ActiveRecord::Base
    has_many :transfers
    has_many :inventory, through: :transfers
    belongs_to :user
    validates :name, presence: true
    validates :address, presence: true
    validates :contact_person, presence: true
    validates :email, presence: true
    validates :phone_number, presence: true
end