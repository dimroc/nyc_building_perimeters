class Socrata::Loader
  include Enumerable

  attr_reader :columns

  def initialize(json)
    @information = JSON.parse(json)
    @columns = @information["meta"]["view"]["columns"]
  end

  def each
    @information["data"].each do |row|
      yield row
    end
  end
end
