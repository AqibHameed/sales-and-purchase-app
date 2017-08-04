module Api
  module V1
    class TendersController <ApiController
      # before_action :current_customer

      def index
        col_str = ""
        if params[:location] || params[:month] || params[:supplier]
          col_str =  "(tenders.country LIKE '%#{params[:location]}%')"  unless params[:location].blank?
          col_str += (col_str.blank?) ? "extract(month from open_date) = #{params[:month]}" : " AND extract(month from open_date) = #{params[:month]}" unless params[:month].blank?
          col_str += (col_str.blank?) ? "tenders.company_id =  #{params[:supplier]}" : " AND tenders.company_id = #{params[:supplier]}" unless params[:supplier].blank?
        end
        if current_customer
          tenders = current_customer.tenders.where(col_str).order("created_at desc")
        else
          tenders = Tender.where(col_str).order("created_at desc")
        end
        render json: { tenders: tender_data(tenders) }
      end

      def upcoming
        col_str = "open_date > '#{Time.now + 2.month}'"
        if current_customer
          tenders = current_customer.tenders.where(col_str).order("created_at desc")
        else
          tenders = Tender.where(col_str).order("created_at desc")
        end
        render json: { success: true, tenders: tender_data(tenders) }
      end

      def tender_parcel
        stones = Stone.where(tender_id: params[:tender_id])
        render json: { success: true, tender_parcels: stone_data(stones) }
      end

      def tender_data(tenders)
        @data = []
        if current_customer
          tenders.each do |tender|
            @data << {
              id: tender.id,
              name: tender.name,
              start_date: tender.open_date,
              end_date: tender.close_date,
              company_name: tender.company.name,
              company_logo: nil,
              city: tender.city,
              country: tender.country,
              notification: tender.check_notification(current_customer)
            }
          end
          @data
        else
          tenders.each do |tender|
            @data << {
              id: tender.id,
              name: tender.name,
              start_date: tender.open_date,
              end_date: tender.close_date,
              company_name: tender.company.name,
              company_logo: nil,
              city: tender.city,
              country: tender.country,
              notification: false
            }
          end
          @data
        end
      end

      def stone_data(stones)
        @stones = []
        stones.each do |stone|
          @stones << {
            id: stone.id,
            stone_type: stone.stone_type,
            no_of_stones: stone.no_of_stones,
            :size => stone.size,
            :weight => stone.weight,
            :carat => stone.carat,
            :purity => stone.purity,
            :color => stone.color,
            :polished => stone.polished,
            :deec_no => stone.deec_no,
            :lot_no => stone.lot_no,
            :description => stone.description,
            :tender => stone.tender
          }
        end
        @stones
      end
    end
  end
end