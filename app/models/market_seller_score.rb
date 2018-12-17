class MarketSellerScore < ApplicationRecord

  def self.calculate_scores(is_new = true)
    avg_scores = false
    #calculate scores
    result = SellerScore.select("
      SUM(late_payment) as late_payment,
      SUM(current_risk) as current_risk,
      SUM(network_diversity) as network_diversity,
      SUM(seller_network) as seller_network,
      SUM(due_date) as due_date,
      SUM(credit_used) as credit_used,
      '1' as actual
    ").where("actual = ?", true).limit(1).first
    sellers_count = SellerScore.where("actual = ?", true).count

    if is_new
      #clear "actual" flag
      MarketSellerScore.update_all(actual: false)
      avg_scores = MarketSellerScore.create(
          actual: true,
          late_payment: (result.late_payment/sellers_count).round(2),
          current_risk: (result.current_risk/sellers_count).round(2),
          network_diversity: (result.network_diversity/sellers_count).round(2),
          seller_network: (result.seller_network/sellers_count).round(2),
          due_date: (result.due_date/sellers_count).round(2),
          credit_used: (result.credit_used/sellers_count).round(2),
          created_at: Time.now,
          updated_at: Time.now
      )
    else
      actual_score = self.get_scores
      unless actual_score.nil?
        actual_score.update(
            late_payment: (result.late_payment/sellers_count).round(2),
            current_risk: (result.current_risk/sellers_count).round(2),
            network_diversity: (result.network_diversity/sellers_count).round(2),
            seller_network: (result.seller_network/sellers_count).round(2),
            due_date: (result.due_date/sellers_count).round(2),
            credit_used: (result.credit_used/sellers_count).round(2),
            updated_at: Time.now
        )
        avg_scores = actual_score
      end
    end

    return avg_scores
  end

  def self.get_scores
    scores = MarketSellerScore.where("actual = ?", true).order(:created_at).last
    if scores.nil?
      scores = MarketSellerScore.new
      scores.actual = true
      scores.late_payment = 0
      scores.current_risk = 0
      scores.network_diversity = 0
      scores.seller_network = 0
      scores.due_date = 0
      scores.credit_used = 0
      scores.created_at = Time.now
      scores.updated_at = Time.now
      scores.save
    end
    return scores
  end

end
