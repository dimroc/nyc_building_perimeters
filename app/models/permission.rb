class Permission < SimpleDelegator
  def initialize(ability)
    super
    grant_permissions
  end

  private

  def grant_permissions
    self.methods.grep(/grant_.*_permissions/).each do |method|
      self.send(method)
    end
  end
end
