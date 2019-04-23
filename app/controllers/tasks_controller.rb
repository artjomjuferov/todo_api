class TasksController < ApplicationController
  before_action :set_task, only: %i[update tag destroy]

  INDEX_PER_PAGE = 10

  def create
    task = Task.create(title: params[:title])
    head create_status(task)
  end

  def update
    return head :not_found unless @task
    @task.update(title: params[:title])
    head update_status(@task)
  end

  def index
    tasks = Task.all
    paginate json: tasks, per_page: INDEX_PER_PAGE, status: :ok
  end

  def tag
    return head :not_found unless @task
    set_tag
    return head :unprocessable_entity unless @tag.valid?
    @task.tags << @tag unless @task.tags.include?(@tag)
    head :created
  end

  def destroy
    return head :not_found unless @task
    @task.destroy
    head :ok
  end

  private

  def create_status(task)
    task.valid? ? :created : :unprocessable_entity
  end

  def update_status(task)
    task.valid? ? :ok : :unprocessable_entity
  end

  def set_task
    @task = Task.find_by(id: params[:id])
  end

  def set_tag
    @tag = Tag.find_or_create_by(name: params[:name])
  end
end
