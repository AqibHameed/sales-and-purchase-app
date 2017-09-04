class TradingDocument < ApplicationRecord
	belongs_to :customer

	has_attached_file :document
  do_not_validate_attachment_file_type :document

  after_save :create_trading_parcels_from_uploaded_file

  def create_trading_parcels_from_uploaded_file
  	if self.document_updated_at_changed?
      data_file = Spreadsheet.open(self.document.path)
      worksheet = data_file.worksheet(self.sheet_no.to_i - 1)
      unless worksheet.nil?
        worksheet.each_with_index do |data_row, i|
          unless i == 0 || i == 1
            unless data_row[('A'..'AZ').to_a.index(self.lot_no_field)].nil?
            	parcel = TradingParcel.where(lot_no: TradingDocument.get_value(data_row[TradingDocument.get_index(self.lot_no_field)]), trading_document_id: self.id).first_or_initialize
              parcel.lot_no = TradingDocument.get_value(data_row[TradingDocument.get_index(self.lot_no_field)]) unless self.lot_no_field.blank?
              parcel.credit_period = TradingDocument.get_value(data_row[TradingDocument.get_index(self.credit_field)]) unless self.credit_field.blank?
              parcel.description = TradingDocument.get_value(data_row[TradingDocument.get_index(self.desc_field)]) unless self.desc_field.blank?
              parcel.no_of_stones = TradingDocument.get_value(data_row[TradingDocument.get_index(self.no_of_stones_field)]) unless self.no_of_stones_field.blank?
              parcel.weight = TradingDocument.get_value(data_row[TradingDocument.get_index(self.weight_field)]) unless self.weight_field.blank?
              parcel.customer_id = self.customer_id
              parcel.company_id = nil
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
    return ((data.class == Fixnum or data.class == Float)  ? data : (data.class == String ? data : data.nil? ? nil : data.value))
  end
end

