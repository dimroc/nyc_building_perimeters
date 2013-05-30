class Permission::Standard < Permission
  def grant_standard_permissions
    can :manage, Block
  end
end
