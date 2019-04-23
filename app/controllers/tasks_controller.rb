class TasksController < ApplicationController
  before_action :set_task, only: %i[update tag destroy]

  INDEX_PER_PAGE = 10

  def create
    @task = Task.create(title: params[:title])
    if @task.valid?
      render json: @task, serializer: TaskSerializer, status: '201'
    else
      render json: {errors: task_attribute_errors}
    end
  end

  def update
    return task_not_found unless @task
    @task.update(title: params[:title])
    if @task.valid?
      render json: @task, serializer: TaskSerializer, status: '200'
    else
      render json: {errors: task_attribute_errors}
    end
  end

  def index
    tasks = Task.all
    paginate json: tasks,
             each_serializer: TaskSerializer,
             per_page: per_page,
             status: :ok
  end

  def tag
    return task_not_found unless @task
    set_tag
    if @tag.valid?
      @task.tags << @tag unless @task.tags.include?(@tag)
      render json: @task, serializer: TaskSerializer, status: '200'
    else
      render json: {errors: tag_attribute_errors}
    end
  end

  def destroy
    return task_not_found unless @task
    @task.destroy
    render json: @task, serializer: TaskSerializer, status: '200'
  end

  private

  def per_page
    params.dig(:page, :size) || INDEX_PER_PAGE
  end

  def set_task
    @task = Task.find_by(id: params[:id])
  end

  def set_tag
    @tag = Tag.find_or_create_by(name: params[:name])
  end

  def task_attribute_errors
    @task.errors.map do |field, message|
      {
        title: "#{field.to_s.humanize} #{message}",
        status: '422',
        source: {
          pointer: "data/attributes/#{field}"
        }
      }
    end
  end

  def tag_attribute_errors
    @tag.errors.map do |field, message|
      {
        title: "#{field.to_s.humanize} #{message}",
        status: '422',
        source: {
          pointer: "data/attributes/tags/#{field}"
        }
      }
    end
  end

  def task_not_found
    render json: {
      errors: [
        {
          title: 'Task does not exist',
          status: '404',
          source: {
            pointer: 'data/id'
          }
        }
      ]
    }
  end
end
