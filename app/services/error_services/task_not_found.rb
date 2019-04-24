class ErrorServices::TaskNotFound < ErrorService
  private

  def errors
    [
      {
        title: 'Task does not exist',
        status: '404',
        source: {
          pointer: 'data/id'
        }
      }
    ]
  end
end
