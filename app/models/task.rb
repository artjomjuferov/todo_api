class Task < ApplicationRecord
  TAGS_LIMIT = 100

  validates :title, presence: true, uniqueness: true
  validate :tags_limits

  has_many :tasks_tags
  has_many :tags, through: :tasks_tags

  private

  def tags_limits
    errors.add(:tags, "Limit for tags is #{TAGS_LIMIT}") if tags.size > TAGS_LIMIT
  end
end
