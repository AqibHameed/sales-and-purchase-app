class DemandList < ApplicationRecord
  validates :demand_supplier_id, :description, presence: true
  belongs_to :demand_supplier

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
    list do
      [:id, :description, :created_at, :updated_at].each do |field_name|
        field field_name
      end
      field :demand_supplier do
        formatted_value do # used in form views
          value.demand_supplier.name
        end
      end
    end
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
