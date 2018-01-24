class Ability
  include CanCan::Ability

  def initialize(customer)
    # Define abilities for the passed in user here. For example:
    #
    # customer ||= Customer.new # guest user (not logged in)
    if customer.class == Admin
      can :manage, :all
    else
      if customer.has_role?('Broker')
        can :access, :broker
        can :access, :sell
        can :access, :buy
      end
      if customer.has_role?('Supplier')
        can :access, :auctions
      end
      if customer.has_role?('Seller')
        can :access, :sell
      end
      if customer.has_role?('Buyer')
        can :access, :buy
      end
    end
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
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
