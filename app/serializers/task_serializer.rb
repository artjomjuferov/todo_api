class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :tags, :updated_at, :created_at

  def tags
    self.object.tags.map {|tag| {name: tag.name}}
  end
end
