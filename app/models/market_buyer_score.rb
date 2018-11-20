class MarketBuyerScore < ApplicationRecord

  def self.calculate_scores(is_new = true)
    avg_scores = false
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
    buyers_count = BuyerScore.where("actual = ?", true).count

    if is_new
      #clear "actual" flag
      MarketBuyerScore.update_all(actual: false)
      avg_scores = MarketBuyerScore.create(
          actual: true,
          late_payment: (result.late_payment/buyers_count).round(2),
          current_risk: (result.current_risk/buyers_count).round(2),
          network_diversity: (result.network_diversity/buyers_count).round(2),
          buyer_network: (result.buyer_network/buyers_count).round(2),
          due_date: (result.due_date/buyers_count).round(2),
          credit_used: (result.credit_used/buyers_count).round(2),
          count_of_credit_given: (result.count_of_credit_given/buyers_count).round(2),
          created_at: Time.current,
          updated_at: Time.current
      )
    else
      actual_score = self.get_scores
      unless actual_score.nil?
        actual_score.update(
            late_payment: (result.late_payment/buyers_count).round(2),
            current_risk: (result.current_risk/buyers_count).round(2),
            network_diversity: (result.network_diversity/buyers_count).round(2),
            buyer_network: (result.buyer_network/buyers_count).round(2),
            due_date: (result.due_date/buyers_count).round(2),
            credit_used: (result.credit_used/buyers_count).round(2),
            count_of_credit_given: (result.count_of_credit_given/buyers_count).round(2),
            updated_at: Time.current
        )
        avg_scores = actual_score
      end
    end

    return avg_scores
  end

  def self.get_scores
    scores = MarketBuyerScore.where("actual = ?", true).order(:created_at).last 
    if scores.nil?
      scores.MarketBuyerScore.new
      scores.actual = true
      scores.late_payment = 0,
      scores.current_risk = 0,
      scores.network_diversity = 0,
      scores.buyer_network = 0,
      scores.due_date = 0,
      scores.credit_used = 0,
      scores.count_of_credit_given = 0,
      scores.created_at = Time.current,
      scores.updated_at = Time.current
      scores.save
    end
    return scores
  end

end
