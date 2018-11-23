module Api
  module V1
    class TendersController <ApiController
      before_action :current_customer
      protect_from_forgery with: :null_session
      skip_before_action :verify_authenticity_token, only: [:index]

      def index
        col_str = ""
        if params[:location] || params[:month] || params[:supplier]
          col_str = "(lower(tenders.country) LIKE '%#{params[:location].downcase}%')" unless params[:location].blank?
          col_str += (col_str.blank?) ? "extract(month from open_date) = #{params[:month]}" : " AND extract(month from open_date) = #{params[:month]}" unless params[:month].blank?
          col_str += (col_str.blank?) ? "tenders.supplier_id =  #{params[:supplier]}" : " AND tenders.supplier_id = #{params[:supplier]}" unless params[:supplier].blank?
        end
        @tenders = Tender.includes(:supplier).tenders_state(params[:state]).where(col_str).order("open_date")
        # @tenders = tender.page(params[:page]).pcoer(params[:count])
        #render json: { success: true, pagination: set_pagination(:tenders), tenders: tender_data(@tenders), response_code: 200 }
        render json: {success: true, tenders: tender_data(@tenders), response_code: 200}
      end

      def upcoming
        col_str = "open_date > '#{Time.zone.now}'"
        if params[:location] || params[:month] || params[:supplier]
          col_str += " AND (tenders.country LIKE '%#{params[:location]}%')" unless params[:location].blank?
          col_str += (col_str.blank?) ? "extract(month from open_date) = #{params[:month]}" : " AND extract(month from open_date) = #{params[:month]}" unless params[:month].blank?
          col_str += (col_str.blank?) ? "tenders.supplier_id =  #{params[:supplier]}" : " AND tenders.supplier_id = #{params[:supplier]}" unless params[:supplier].blank?
        end
        if current_customer
          tender = Tender.where(col_str).order("open_date")
        else
          tender = Tender.where(col_str).order("open_date")
        end
        @tenders = tender.page(params[:page]).per(params[:count])
        render json: {success: true, pagination: set_pagination(:tenders), tenders: tender_data(@tenders), response_code: 200}
        # col_str = ""
        # upcoming_str = "open_date > '#{Time.zone.now}'"
        # if params[:location] || params[:month] || params[:supplier]
        #   col_str =  "(lower(tenders.country) LIKE '%#{params[:location].downcase}%')"  unless params[:location].blank?
        #   col_str += (col_str.blank?) ? "extract(month from open_date) = #{params[:month]}" : " AND extract(month from open_date) = #{params[:month]}" unless params[:month].blank?
        #   col_str += (col_str.blank?) ? "tenders.company_id =  #{params[:supplier]}" : " AND tenders.company_id = #{params[:supplier]}" unless params[:supplier].blank?
        # end
        # if current_customer
        #   active_tenders = current_customer.tenders.active.where(col_str).order("created_at desc")
        #   upcoming_tenders = current_customer.tenders.where(upcoming_str).where(col_str).order("created_at desc")
        # else
        #   active_tenders = Tender.active.where(col_str).order("created_at desc")
        #   upcoming_tenders = Tender.where(upcoming_str).where(col_str).order("created_at desc")
        # end
        # tenders = active_tenders + upcoming_tenders
        # render json: { tenders: tender_data(tenders), response_code: 200 }
      end

      def closed
        col_str = "close_date < '#{Time.zone.now}' AND close_date > '#{4.month.ago}'"
        if params[:location] || params[:month] || params[:supplier]
          col_str += " AND (tenders.country LIKE '%#{params[:location]}%')" unless params[:location].blank?
          col_str += (col_str.blank?) ? "extract(month from open_date) = #{params[:month]}" : " AND extract(month from open_date) = #{params[:month]}" unless params[:month].blank?
          col_str += (col_str.blank?) ? "tenders.supplier_id =  #{params[:supplier]}" : " AND tenders.supplier_id = #{params[:supplier]}" unless params[:supplier].blank?
        end
        if current_customer
          tenders = Tender.where(col_str).order("created_at desc")
        else
          tenders = Tender.where(col_str).order("created_at desc")
        end
        render json: {success: true, tenders: closed_tender_data(tenders), response_code: 200}
      end

      def old_tenders
        col_str = ""
        if params[:location] || params[:month] || params[:supplier]
          col_str = "(lower(tenders.country) LIKE '%#{params[:location].downcase}%')" unless params[:location].blank?
          col_str += (col_str.blank?) ? "extract(month from open_date) = #{params[:month]}" : " AND extract(month from open_date) = #{params[:month]}" unless params[:month].blank?
          col_str += (col_str.blank?) ? "tenders.supplier_id =  #{params[:supplier]}" : " AND tenders.supplier_id = #{params[:supplier]}" unless params[:supplier].blank?
        end
        if current_customer
          tender = Tender.active.where(col_str).order("open_date")
        else
          tender = Tender.active.where(col_str).order("open_date")
        end
        @tenders = tender.page(params[:page]).per(params[:count])
        render json: {success: true, pagination: set_pagination(:tenders), tenders: old_tender_data(@tenders), response_code: 200}
      end

      def old_upcoming
        col_str = "open_date > '#{Time.zone.now}'"
        if params[:location] || params[:month] || params[:supplier]
          col_str += " AND (tenders.country LIKE '%#{params[:location]}%')" unless params[:location].blank?
          col_str += (col_str.blank?) ? "extract(month from open_date) = #{params[:month]}" : " AND extract(month from open_date) = #{params[:month]}" unless params[:month].blank?
          col_str += (col_str.blank?) ? "tenders.supplier_id =  #{params[:supplier]}" : " AND tenders.supplier_id = #{params[:supplier]}" unless params[:supplier].blank?
        end
        if current_customer
          tenders = Tender.where(col_str).order("open_date")
        else
          tenders = Tender.where(col_str).order("open_date")
        end
        render json: {success: true, tenders: old_tender_data(tenders), response_code: 200}
        # col_str = ""
        # upcoming_str = "open_date > '#{Time.zone.now}'"
        # if params[:location] || params[:month] || params[:supplier]
        #   col_str =  "(lower(tenders.country) LIKE '%#{params[:location].downcase}%')"  unless params[:location].blank?
        #   col_str += (col_str.blank?) ? "extract(month from open_date) = #{params[:month]}" : " AND extract(month from open_date) = #{params[:month]}" unless params[:month].blank?
        #   col_str += (col_str.blank?) ? "tenders.company_id =  #{params[:supplier]}" : " AND tenders.company_id = #{params[:supplier]}" unless params[:supplier].blank?
        # end
        # if current_customer
        #   active_tenders = current_customer.tenders.active.where(col_str).order("created_at desc")
        #   upcoming_tenders = current_customer.tenders.where(upcoming_str).where(col_str).order("created_at desc")
        # else
        #   active_tenders = Tender.active.where(col_str).order("created_at desc")
        #   upcoming_tenders = Tender.where(upcoming_str).where(col_str).order("created_at desc")
        # end
        # tenders = active_tenders + upcoming_tenders
        # render json: { tenders: tender_data(tenders), response_code: 200 }
      end

      def old_tender_parcel
        stones = Stone.where(tender_id: params[:tender_id])
        render json: {success: true, tender_parcels: winners_stone_data(stones), response_code: 200}
      end

      def tender_parcel
        stones = Stone.includes(:stone_ratings).where(tender_id: params[:tender_id])
        render json: {success: true, tender_parcels: stone_data(stones), response_code: 200}
      end

      def stone_parcel
        if current_customer
          stone_parcel = Stone.where(id: params[:id]).first
          if stone_parcel.nil?
            errors = ['Parcel not found']
            render :json => {:errors => errors, response_code: 201}
          else
            stone_rating = StoneRating.where(stone_id: stone_parcel.id, customer_id: current_customer.id).first
            if stone_rating.nil?
              stone_rating = StoneRating.new(comments: params[:comments], valuation: params[:valuation], parcel_rating: params[:parcel_rating], stone_id: stone_parcel.id, customer_id: current_customer.id)
            else
              stone_rating.comments = params[:comments] unless params[:comments].blank?
              stone_rating.parcel_rating = params[:parcel_rating] unless params[:parcel_rating].blank?
              stone_rating.valuation = params[:valuation] unless params[:valuation].blank?
            end
            if stone_rating.save
              render :json => {stone_parcel: rating_stone_parcel(stone_rating), response_code: 200}
            else
              render :json => {:errors => stone_rating.errors.full_messages, response_code: 201}
            end
          end
        else
          render json: {errors: "Not authenticated", response_code: 201}, status: :unauthorized
        end
      end

      def find_active_parcels
        if params[:term].nil? || params[:term].blank?
          render json: {errors: "Invalid Parameters", response_code: 201}
        else
          terms = params[:term].split(' ').map(&:to_f).delete_if {|i| i==0.0}
          @parcels = []
          begin
            terms.each do |term|
              @parcels << Stone.active_parcels(term)
            end
          rescue => e
            render json: {success: true, error: 'Something went wrong. Please try again with different image.', response_code: 201}
          else
            render json: {success: true, parcels: active_parcel_data(@parcels.flatten), response_code: 200}
          end
        end
      end

      def tender_winners
        tender_winners = TenderWinner.where(tender_id: params[:tender_id])
        if tender_winners.empty?
          render json: {tender_winners: [], response_code: 200}
        else
          render json: {tender_winners: tender_winners_data(tender_winners), response_code: 200}
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
                company_name: tender.supplier.try(:name),
                company_logo: nil,
                city: tender.city,
                country: tender.country,
                notification: tender.check_notification(current_customer),
                ##tender_parcels: stone_data(tender.stones)
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
                company_name: tender.supplier.try(:name),
                company_logo: nil,
                city: tender.city,
                country: tender.country,
                notification: false,
                #tender_parcels: stone_data(tender.stones)
            }
          end
          @data
        end
      end

      def old_tender_data(tenders)
        @data = []
        if current_customer
          tenders.each do |tender|
            @data << {
                id: tender.id,
                name: tender.name,
                start_date: tender.open_date,
                end_date: tender.close_date,
                company_name: tender.supplier.try(:name),
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
                company_name: tender.supplier.try(:name),
                company_logo: nil,
                city: tender.city,
                country: tender.country,
                notification: false
            }
          end
          @data
        end
      end

      def winners_stone_data(stones)
        @stones = []
        stones.each do |stone|
          stone_rating = StoneRating.where(customer_id: current_customer.try(:id), stone_id: stone.id).first
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
              :comments => stone_rating.try(:comments),
              :valuation => stone_rating.try(:valuation),
              :parcel_rating => stone_rating.try(:parcel_rating),
              :images => parcel_images(stone),
              :winners_data => historical_data(stone.try(:tender).try(:id), stone)
          }
        end
        @stones
      end

      def stone_data(stones)
        @stones = []
        stones.each do |stone|
          stone_rating = stone.stone_ratings.where(customer_id: current_customer.try(&:id)).last
          @stones << {
              id: stone.id,
              stone_type: stone.stone_type,
              no_of_stones: stone.no_of_stones,
              size: stone.size,
              weight: stone.weight,
              purity: stone.purity,
              color: stone.color,
              polished: stone.polished,
              deec_no: stone.deec_no,
              lot_no: stone.lot_no,
              description: stone.description,
              comments: stone_rating.try(:comments),
              valuation: stone_rating.try(:valuation),
              parcel_rating: stone_rating.try(:parcel_rating),
              images: parcel_images(stone),
              winners_data: historical_data(stone.try(:tender).try(:id), stone)
          }
        end
        @stones
      end

      def historical_data(id, stone)
        @w = []
        if stone.no_of_stones.to_i == 1
          # do nothing
        else
          desc = stone.description
          tender = current_customer.tenders.find(id) rescue Tender.find(id)
          tenders = Tender.includes(:tender_winners).where("id != ? and supplier_mine_id = ? and date(close_date) < ?", tender.id, tender.supplier_mine_id, tender.open_date.to_date).order("open_date DESC").limit(5)
          # winners = TenderWinner.includes(:tender).where("tender_id in (?) and tender_winners.description = ?", tenders.collect(&:id), desc)
          tender_winner_array = TenderWinner.includes(:tender).where(description: desc, tender_id: tenders.collect(&:id)).order("avg_selling_price desc").group_by {|t| t.tender.close_date.beginning_of_month}
          @winners = []
          tender_winner_array.each_pair do |tender_winner|
            @winners << tender_winner.try(:last).try(:first)
          end
          @winners = @winners.compact.sort_by {|e| e.tender.open_date}.reverse

          @winners.each do |winner|
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
        end
        @w
      end

      def active_parcel_data(stones)
        @stones = []
        duplicate_stones = stones.select {|item| stones.count(item) > 1}.uniq
        if duplicate_stones.empty?
          stones = stones
        else
          stones = duplicate_stones
        end
        stones.each do |stone|
          stone_rating = StoneRating.where(customer_id: current_customer.try(:id), stone_id: stone.id).first
          @stones << {
              id: stone.id,
              :description => stone.description,
              created_at: stone.created_at,
              updated_at: stone.updated_at,
              stone_type: stone.stone_type,
              no_of_stones: stone.no_of_stones,
              :size => stone.size,
              :weight => stone.weight,
              :purity => stone.purity,
              :color => stone.color,
              :polished => stone.polished,
              :deec_no => stone.deec_no,
              :lot_no => stone.lot_no,
              :comments => stone_rating.try(:comments),
              :valuation => stone_rating.try(:valuation),
              :parcel_rating => stone_rating.try(:parcel_rating),
              :tender_name => stone.name
          }
        end
        @stones
      end

      def tender_winners_data(tender_winners)
        winners = []
        tender_winners.each do |winner|
          stone = Stone.where(tender_id: winner.tender_id, lot_no: winner.lot_no).first
          unless stone.nil?
            winners << {
                description: winner.description,
                weight: stone.try(:weight),
                comments: stone.comments,
                valuation: stone.valuation,
                parcel_rating: stone.parcel_rating,
                size: stone.size,
                purity: stone.purity,
                color: stone.color,
                polished: stone.polished,
                deec_no: stone.deec_no,
                lot_no: stone.lot_no,
                selling_price: winner.selling_price,
                avg_selling_price: winner.avg_selling_price,
                tender_name: winner.tender.name
            }
          end
        end
        winners
      end

      def closed_tender_data(tenders)
        @data = []
        if current_customer
          tenders.each do |tender|
            @data << {
                id: tender.id,
                name: tender.name,
                start_date: tender.open_date,
                end_date: tender.close_date,
                company_name: tender.supplier.try(:name),
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
                company_name: tender.supplier.try(:name),
                company_logo: nil,
                city: tender.city,
                country: tender.country,
                notification: false
            }
          end
          @data
        end
      end

      def rating_stone_parcel(stone_rating)
        stone = stone_rating.stone
        {
            id: stone.id,
            comments: stone_rating.comments,
            valuation: stone_rating.valuation,
            parcel_rating: stone_rating.parcel_rating,
            lot_no: stone.lot_no,
            tender_id: stone.tender_id,
            description: stone.description,
            no_of_stones: stone.no_of_stones,
            weight: stone.weight,
            carat: stone.carat,
            stone_type: stone.stone_type,
            size: stone.size,
            purity: stone.purity,
            color: stone.color,
            polished: stone.polished,
            created_at: stone.created_at,
            updated_at: stone.updated_at,
            deec_no: stone.deec_no,
            system_price: stone.system_price,
            lot_permission: stone.lot_permission,
            reserved_price: stone.reserved_price,
            yes_no_system_price: stone.yes_no_system_price,
            stone_winning_price: stone.stone_winning_price
        }
      end

      def parcel_images(stone)
        if current_customer
          stone.parcel_images.where(customer_id: current_customer.id).map {|e| e.try(:image_url)}.compact
        else
          []
        end
      end
    end
  end
end