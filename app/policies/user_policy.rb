class UserPolicy < ApplicationPolicy
  def show?
    update?
  end

  def update?
    user.id == record.id
  end

  def destroy?
    current_user = user
  end
end
