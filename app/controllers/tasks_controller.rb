class TasksController < ApplicationController

  def create
    task = Task.create(title: params[:title])
    status = task.valid? ? :created : :unprocessable_entity
    head status
  end

  def update
    task = Task.find_by(id: params[:id])
    return head :not_found unless task
    task.update(title: params[:title])
    status = task.valid? ? :ok : :unprocessable_entity
    head status
  end

  def index
  end

  def tag
  end

  def destroy
  end
end
