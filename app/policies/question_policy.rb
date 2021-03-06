class QuestionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.admin? ? scope.all : scope.where(user: user)
    end
  end

  def index?
    user.present?
  end

  def show?
    user.admin? || record.user_id == user.id
  end

  def create?
    user.present?
  end

  def update?
    reproved_question_belongs_to_user?
  end

  def destroy?
    user.admin? || record.user_id == user.id
  end

  def analyses?
    admin_and_pending_question?
  end

  def approve?
    admin_and_pending_question? && !record.approved_at?
  end

  def reprove?
    admin_and_pending_question? && !record.reproved_at?
  end

  def comment?
    reprove?
  end

  private

  def admin_and_pending_question?
    user.admin? && record.pending_at?
  end

  def reproved_question_belongs_to_user?
    record.user_id == user.id && record.reproved_at?
  end
end
