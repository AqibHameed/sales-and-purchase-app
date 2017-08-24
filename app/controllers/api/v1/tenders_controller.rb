module Api
  module V1
    class TendersController <ApiController
      # before_action :current_customer
      skip_before_action :verify_authenticity_token, only: [:stone_parcel]

      def index
        col_str = ""
        if params[:location] || params[:month] || params[:supplier]
          col_str =  "(tenders.country LIKE '%#{params[:location]}%')"  unless params[:location].blank?
          col_str += (col_str.blank?) ? "extract(month from open_date) = #{params[:month]}" : " AND extract(month from open_date) = #{params[:month]}" unless params[:month].blank?
          col_str += (col_str.blank?) ? "tenders.company_id =  #{params[:supplier]}" : " AND tenders.company_id = #{params[:supplier]}" unless params[:supplier].blank?
        end
        if current_customer
          tenders = current_customer.tenders.active.where(col_str).order("created_at desc")
        else
          tenders = Tender.active.where(col_str).order("created_at desc")
        end
        render json: { tenders: tender_data(tenders), response_code: 200 }
      end

      def upcoming
        col_str = "open_date > '#{Time.now + 2.month}'"
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
        render json: { success: true, tenders: tender_data(tenders), response_code: 200 }
      end

      def tender_parcel
        stones = Stone.where(tender_id: params[:tender_id])
        render json: { success: true, tender_parcels: stone_data(stones), response_code: 200 }
      end

      def stone_parcel
        stone_parcel = Stone.where(id: params[:id]).first
        if stone_parcel.nil?
          errors = ['Parcel not found']
          render :json => { :errors => errors, response_code: 201 }
        else
          if stone_parcel.update(comments: params[:comments], valuation:  params[:valuation], parcel_rating:  params[:parcel_rating])
            render :json => { stone_parcel: stone_parcel, response_code: 200 }
          else
            render :json => {:errors => stone_parcel.errors.full_messages, response_code: 201 }
          end
        end
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
            :purity => stone.purity,
            :color => stone.color,
            :polished => stone.polished,
            :deec_no => stone.deec_no,
            :lot_no => stone.lot_no,
            :description => stone.description,
            :comments => stone.comments,
            :valuation => stone.valuation,
            :parcel_rating => stone.parcel_rating,
            :tender => stone.tender,
            :winners_data => historical_data(stone.try(:tender).try(:id), stone.description)
          }
        end
        @stones
      end

      def historical_data(id, desc)
        @w = []
        tender = current_customer.tenders.find(id) rescue Tender.find(id)
        tenders = Tender.includes(:tender_winners).where("id != ? and company_id = ? and date(close_date) < ?", tender.id, tender.company_id, tender.open_date.to_date).order("open_date DESC").limit(5)
        winners = TenderWinner.includes(:tender).where("tender_id in (?) and tender_winners.description = ?", tenders.collect(&:id), desc)
        winners.each do |winner|
          @w << {
            tender_id: winner.tender_id,
            lot_no: winner.lot_no,
            selling_price: winner.selling_price,
            created_at: winner.created_at,
            updated_at: winner.updated_at,
            description: winner.description,
            avg_selling_price: winner.avg_selling_price
          }
        end
        @w
      end
    end
  end
end