module Api
  module V1
    class TendersController <ApiController
      # before_action :current_customer
      def index
        col_str = ""
        if params[:location] || params[:month] || params[:supplier]
          col_str =  "(tenders.city LIKE '%#{params[:location]}%' OR tenders.country LIKE '%#{params[:location]}%')"  unless params[:location].blank?
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

      def tender_data(tenders)
        @data = []
        tenders.each do |tender|
          @data << {
            id: tender.id,
            name: tender.name,
            start_date: tender.open_date,
            end_date: tender.close_date,
            company_name: tender.company.name,
            company_logo: nil,
            city: tender.city,
            country: tender.country
          }
        end
        @data
      end
    end
  end
end