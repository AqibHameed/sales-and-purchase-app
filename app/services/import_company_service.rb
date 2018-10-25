class ImportCompanyService
  def initialize(file)
    @file = file
  end

  def import
    data_file = Spreadsheet.open(open(@file))
    worksheet = data_file.worksheet(0)
    unless worksheet.nil?
      worksheet.each_with_index do |row, i|
        unless i == 0
          if row[0].nil? && row[1].nil?
            return true
          else
            company = Company.where(name: row[0].strip , county: row[1].strip).first
            Company.create(name: row[0].strip , county: row[1].strip) unless company
          end
        end
      end
    end
  end
end