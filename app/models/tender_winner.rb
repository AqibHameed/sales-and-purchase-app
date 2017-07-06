class TenderWinner < ApplicationRecord

  attr_accessible :lot_no, :description, :selling_price, :avg_selling_price, :tender_id

  validates_presence_of :lot_no, :selling_price, :tender_id
  validates_numericality_of :selling_price, :lot_no, :avg_selling_price

  belongs_to :tender
  def self.search_results(filters, current_customer, history_page = false)
    query = []
    unless filters.blank?
      query << "tenders.id in (#{filters[:name]})" unless filters[:name].blank?
      query << "tenders.open_date >= '#{filters[:start_date].to_datetime.beginning_of_day}'" unless filters[:start_date].blank?
      query << "tenders.close_date <= '#{filters[:end_date].to_datetime.end_of_day}'" unless filters[:end_date].blank?
      query << "(tenders.open_date <= '#{filters[:specific_date].to_datetime.end_of_day}' AND tenders.open_date >= '#{filters[:specific_date].to_datetime.beginning_of_day}') OR (close_date <= '#{filters[:specific_date].to_datetime.end_of_day}' AND close_date >= '#{filters[:specific_date].to_datetime.beginning_of_day}')" unless filters[:specific_date].blank?
      query << "stones.stone_type like '%#{filters[:type]}%'" unless filters[:type].blank?
      query << "stones.description like '%#{filters[:description]}%'" unless filters[:description].blank?
      query << "stones.weight like '%#{filters[:size]}%'" unless filters[:size].blank?
      query << "stones.carat = '#{filters[:carat]}'" unless filters[:carat].blank?
      query << "stones.color = '#{filters[:color]}'" unless filters[:color].blank?
      query << "stones.purity = '#{filters[:purity]}'" unless filters[:purity].blank?
    end
    query = query.join(' AND ')

    self.find_by_sql("select tenders.name as tender_name, tenders.close_date as date, stones.description as description, stones.weight as weight,  \
                      stones.stone_type as stone_type,stones.deec_no as deec_no, tender_winners.selling_price as selling_price from tenders, stones, tender_winners #{ query == "" ? '' : 'where'} #{query} #{ query == "" ? 'where' : 'and'} tenders.id = tender_winners.tender_id and tenders.id = stones.tender_id and stones.deec_no = tender_winners.lot_no  limit 100")

  end

  rails_admin do
    label "Result"
    list do
      [:tender,:lot_no, :selling_price, :avg_selling_price, :description].each do |field_name|
        field field_name
      end
    end

  end

end