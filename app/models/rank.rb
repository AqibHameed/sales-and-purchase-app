class Rank < ApplicationRecord
  belongs_to :company

  def self.update_rank
    rank = ''
    companies_total_average = []
    comapnies = Company.all
    comapnies.each do |company|
      companies_total_average << count_average(company)
    end
    sorted_average =  companies_total_average.map{|company_average| company_average if company_average[:total_average] != 0}.compact.sort_by {|k| k[:total_average]}.reverse
    total_companies = companies_total_average.count
    ten_percent = ((total_companies / 100.to_f) * 10)
    twenty_percent = ((total_companies / 100.to_f) * 20)
    fourty_percent = ((total_companies / 100.to_f) * 40)
    hundred_percent = ((total_companies / 100.to_f) * 100)
    sorted_average.each do |percentage|
      if sorted_average.index(percentage) <= ten_percent
        rank = 10
      elsif sorted_average.index(percentage) > ten_percent && sorted_average.index(percentage) <= twenty_percent
        rank = 20
      elsif sorted_average.index(percentage) > twenty_percent && sorted_average.index(percentage) <= fourty_percent
        rank = 40
      elsif sorted_average.index(percentage) > fourty_percent && sorted_average.index(percentage) <= hundred_percent
        rank = nil
      end
      rank_data = Rank.find_by(company_id: percentage[:company_id])
      if rank_data.present?
        rank_data.update_attributes(percentage.merge(rank: rank))
      else
        Rank.create(percentage.merge(rank: rank))
      end
    end
  end


  def self.count_average(company)
    current_companies_review = Review.where(company_id: company.id)
    yes_know = current_companies_review.where(know: true).count
    not_know = current_companies_review.where(know: false).count
    yes_trade = current_companies_review.where(trade: true).count
    not_trade = current_companies_review.where(trade: false).count
    yes_recommend = current_companies_review.where(recommend: true).count
    not_recommend = current_companies_review.where(recommend: false).count
    yes_experience = current_companies_review.where(experience: true).count
    not_experience = current_companies_review.where(experience: false).count
    total_number_of_comapnies_rated = current_companies_review.count
    know = (yes_know * 3) + (not_know * (-3))
    trade = (yes_trade * 3) + (not_trade * 0)
    recommend = (yes_recommend * 3) + (not_recommend * 0)
    experience = (yes_experience * 1) + (not_experience * (-3))
    total = know + trade + recommend + experience
    company_data = {
        company_id: company.id,
        total_average: total,
        yes_know: yes_know,
        not_know: not_know,
        yes_trade: yes_trade,
        not_trade: not_trade,
        yes_recommend: yes_recommend,
        not_recommend: not_recommend,
        yes_experience: yes_experience,
        not_experience: not_experience,
        total_number_of_comapnies_rated: total_number_of_comapnies_rated,
        total_know: know,
        total_trade: trade,
        total_recommend: recommend,
        total_experience: experience
    }
    return company_data
  end
end
