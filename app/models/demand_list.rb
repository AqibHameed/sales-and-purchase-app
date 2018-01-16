class DemandList < ApplicationRecord
  validates :demand_supplier_id, :description, presence: true

  def self.import(file, supplier)
    data_file = Spreadsheet.open(open(file))
    worksheet = data_file.worksheet(0)
    unless worksheet.nil?
      worksheet.each_with_index do |row, i|
        DemandList.where(description: row[1], demand_supplier_id: supplier.to_i).first_or_create
      end
    end
  end

  rails_admin do
    edit do
      field :description
      field :demand_supplier_id, :enum do
        label "Supplier"
        enum do
          DemandSupplier.all.map { |c| [ c.name, c.id ] }
        end
      end
    end
  end

end
