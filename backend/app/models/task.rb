class Task < ApplicationRecord
  belongs_to :project, optional: true
  validates :title, presence: true

  attribute :done, :boolean, default: false

  # Attributes: title:string, description:text, deadline:datetime, done:boolean
end
