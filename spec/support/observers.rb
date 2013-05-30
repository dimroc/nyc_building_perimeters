module ObserverSpecHelper
  def enable_observer(observer)
    ActiveRecord::Base.observers.enable observer
  end
end

RSpec.configure do |config|
  config.include(ObserverSpecHelper)

  config.before(:each) do
    ActiveRecord::Base.observers.disable :all
  end
end
