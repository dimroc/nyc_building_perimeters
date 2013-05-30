class Ability
  include CanCan::Ability

  def initialize(user)
    Permission::Standard.new(self)
    # AdminPermission.new(self) if user.has_role? :admin
  end
end
