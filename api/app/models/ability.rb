# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the user here. For example:
    #
    #   return unless user.present?
    #   can :read, :all
    #   return unless user.admin?
    #   can :manage, :all
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md

    # public access to restaurants for read
    can :public_read, Restaurant

    return unless user.present?


    case user
    when Customer
      # ok this seems to work. try with >1 customer and make sure validating correct one
      # also any issue with no delete
      can [:index, :show, :create, :update], Order, customer: user
      can [:index, :create], OrderStatus, order: {customer: user}
    when Owner

      # confirm this is ok with create, show, edit. create is a weird example
      can :manage, Restaurant, owner: user
      can :manage, Meal, restaurant: {owner: user}
      can [:index, :show], Order, restaurant: {owner: user}
      can [:index, :create], OrderStatus, order: {restaurant: {owner: user}}
    else
      raise "Unhandled user type: #{user.class}"
    end

  end
end
