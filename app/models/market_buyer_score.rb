class MarketBuyerScore < ApplicationRecord

  def self.calculate_scores
    #clear "actual" flag
    MarketBuyerScore.update_all(actual: false)
    #calculate scores
    result = BuyerScore.select("
      SUM(late_payment) as late_payment,
      SUM(current_risk) as current_risk,
      SUM(network_diversity) as network_diversity,
      SUM(buyer_network) as buyer_network,
      SUM(due_date) as due_date,
      SUM(credit_used) as credit_used,
      SUM(count_of_credit_given) as count_of_credit_given,
      '1' as actual
    ").where("actual = ?", true).limit(1).first
    #insert new scores
    m = MarketBuyerScore.create(
        actual: true,
        late_payment: result.late_payment,
        current_risk: result.current_risk,
        network_diversity: result.network_diversity,
        buyer_network: result.buyer_network,
        due_date: result.due_date,
        credit_used: result.credit_used,
        count_of_credit_given: result.count_of_credit_given,
        created_at: Time.now,
        updated_at: Time.now
    )
=begin
    puts "!!!!!!!!!!!!!!1"
    puts m.inspect
    puts "!!!!!!!!!!!!!!1"
=end
  end
end
