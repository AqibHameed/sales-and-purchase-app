class TradingDocument < ApplicationRecord
  include DocumentUrl
	belongs_to :customer
  has_one :trading_parcel
  acts_as_paranoid

	has_attached_file :document
  do_not_validate_attachment_file_type :document

  validates :diamond_type, presence: true

  after_save :create_trading_parcels_from_uploaded_file

  def create_trading_parcels_from_uploaded_file
  	if self.document_updated_at_changed?
      file_path = document_url(self.document)
      data_file = Spreadsheet.open(open(file_path))
      worksheet = data_file.worksheet(self.sheet_no.to_i - 1)
      unless worksheet.nil?
        worksheet.each_with_index do |data_row, i|
          if self.diamond_type == 'Sight'
            condition = (i == 0)
          else
            condition = (i == 0 || i == 1)
          end
          unless condition
            unless data_row[('A'..'AZ').to_a.index(self.credit_field)].nil?
            	parcel = TradingParcel.new(trading_document_id: self.id)
              parcel.price = TradingDocument.get_value(data_row[TradingDocument.get_index(self.price_field)]) unless self.price_field.blank?
              parcel.credit_period = TradingDocument.get_value(data_row[TradingDocument.get_index(self.credit_field)]) unless self.credit_field.blank?
              parcel.weight = TradingDocument.get_value(data_row[TradingDocument.get_index(self.weight_field)]) unless self.weight_field.blank?
              if self.diamond_type == 'Rough'
                parcel.lot_no = TradingDocument.get_value(data_row[TradingDocument.get_index(self.lot_no_field)]) unless self.lot_no_field.blank?
                parcel.description = TradingDocument.get_value(data_row[TradingDocument.get_index(self.desc_field)]) unless self.desc_field.blank?
                parcel.no_of_stones = TradingDocument.get_value(data_row[TradingDocument.get_index(self.no_of_stones_field)]) unless self.no_of_stones_field.blank?
                parcel.diamond_type = self.diamond_type
              end
              if self.diamond_type == 'Sight'
                parcel.source = TradingDocument.get_value(data_row[TradingDocument.get_index(self.source_field)]) unless self.source_field.blank?
                parcel.box = TradingDocument.get_value(data_row[TradingDocument.get_index(self.box_field)]) unless self.box_field.blank?
                parcel.box_value = TradingDocument.get_value(data_row[TradingDocument.get_index(self.box_value_field)]) unless self.box_value_field.blank?
                parcel.sight = TradingDocument.get_value(data_row[TradingDocument.get_index(self.sight_field)]) unless self.sight_field.blank?
                parcel.cost = TradingDocument.get_value(data_row[TradingDocument.get_index(self.cost_field)]) unless self.cost_field.blank?
                parcel.diamond_type = self.diamond_type
              end
              parcel.customer_id = self.customer_id
              parcel.save
              puts parcel.errors.full_messages
            end
          end
        end
      end
    end
  end

  def TradingDocument.get_index(alpha)
    ary = ('A'..'AZ').to_a
    puts "===========#{alpha}================"
    puts "===========#{ary.index(alpha)}================"
    return ary.index(alpha)
  end

  def self.get_value(data)
    return ((data.class == Fixnum or data.class == Float)  ? data : (data.class == String ? data : (data.class == Date ? data : data.nil? ? nil : data.value)))
  end
end

