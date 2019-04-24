class ErrorService
  def initialize(record = nil)
    @record = record
  end

  def to_json(opts = nil)
    {errors: errors}.to_json(opts)
  end
end
