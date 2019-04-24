class Api::V1::TasksController < ApplicationController
  before_action :set_task, only: %i[update tag destroy]

  INDEX_PER_PAGE = 10

  def create
    @task = Task.create(title: params[:title])
    if @task.valid?
      render json: @task, serializer: TaskSerializer, status: '201'
    else
      render json: ErrorServices::TaskAttributes.new(@task)
    end
  end

  def update
    return render json: ErrorServices::TaskNotFound.new unless @task
    @task.update(title: params[:title])
    if @task.valid?
      render json: @task, serializer: TaskSerializer, status: '200'
    else
      render json: ErrorServices::TaskAttributes.new(@task)
    end
  end

  def index
    tasks = Task.all
    paginate json: tasks,
             per_page: per_page,
             status: :ok,
             include: 'tags'
  end

  def tag
    return render json: ErrorServices::TaskNotFound.new unless @task
    set_tag
    if @tag.valid?
      @task.tags << @tag unless @task.tags.include?(@tag)
      render json: @task, serializer: TaskSerializer, status: '200'
    else
      render json: ErrorServices::TagAttributes.new(@tag)
    end
  end

  def destroy
    return render json: ErrorServices::TaskNotFound.new unless @task
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
end
