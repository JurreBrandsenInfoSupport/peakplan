class Project < ApplicationRecord
    has_many :tasks, dependent: :destroy
    validates :owner, presence: true
    validates :title, presence: true
end
