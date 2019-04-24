class ErrorServices::TaskAttributes < ErrorService
  private

  def errors
    @record.errors.map do |field, message|
      {
        title: "#{field.to_s.humanize} #{message}",
        status: '422',
        source: {
          pointer: "data/attributes/#{field}"
        }
      }
    end
  end
end
