class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :updated_at, :created_at

  has_many :tags, serializer: TagSerializer
end
