class Developer < ApplicationRecord    
    has_and_belongs_to_many :teams
    validates :full_name, presence: true
    validates :email, presence: true, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}, uniqueness: { case_sensitive: false}
    validates :mobile, presence: true, :numericality => true, :length => { :minimum => 10, :maximum => 12 }, uniqueness: true
end
