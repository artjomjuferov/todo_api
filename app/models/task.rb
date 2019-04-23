class Task < ApplicationRecord
  validates :title, presence: true, uniqueness: true

  has_many :tasks_tags
  has_many :tags, through: :tasks_tags
end
