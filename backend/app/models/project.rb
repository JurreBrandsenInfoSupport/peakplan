class Project < ApplicationRecord
    has_many :tasks
    validates :owner, presence: true
end
