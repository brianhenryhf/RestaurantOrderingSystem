# Note: 'valid' checks are just checks on name (with no other context). 'allowed' checks adhere to
# rules set up here.
class StatusChangeRules
  Rule = Struct.new(:status, :requestable_by_user_classes, :allowed_next_statuses)

  # small number of statuses, so lookup in array should be performant enough
  # nil requestable_by_user_classes means no restriction - though this is only currently applicable for default state
  @@rules = [
    Rule.new(nil, nil, [ 'placed' ]),
    Rule.new('placed', [ Customer ], [ 'processing', 'canceled' ]),
    Rule.new('processing', [ Owner ], [ 'in_route', 'canceled' ]),
    Rule.new('in_route', [ Owner ], [ 'delivered', 'canceled' ]),
    Rule.new('delivered', [ Owner ], [ 'received', 'canceled' ]),
    Rule.new('received', [ Customer ], []),
    Rule.new('canceled', [ Customer, Owner], []),
  ].freeze

  def self.valid_statuses
    @@valid_statuses ||= @@rules.map(&:status).compact
  end

  def valid_status?(proposed_status)
    self.class.valid_statuses.include?(proposed_status)
  end

  def allowed_next_for_current_status?(current_status, proposed_status)
    current_status_rule = rule_for(current_status)
    current_status_rule.allowed_next_statuses.include?(proposed_status)
  end

  # does not care about current_status - this should be checked separately
  def allowed_next_for_user?(proposed_status, user)
    # debugger
    proposed_status_rule = rule_for(proposed_status)
    proposed_status_rule.requestable_by_user_classes.nil? ||
      proposed_status_rule.requestable_by_user_classes.include?(user.class)
  end

  # for UI use.
  def allowed_next_statuses_for_user_class(current_status, user_class)
    current_status_rule = rule_for(current_status)
    all_allowed = current_status_rule.allowed_next_statuses
    all_allowed.filter { |status| self.class.allowed_next_for_user_class?(status, user_class) }
  end

  private

  def rule_for(status)
    rule = @@rules.find { |r| r.status == status }
    raise "Unexpected starting status: #{status}" unless rule.present?

    rule
  end
end
