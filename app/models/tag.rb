class Tag < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :tasks_tags
  has_many :tasks, through: :tasks_tags
end
