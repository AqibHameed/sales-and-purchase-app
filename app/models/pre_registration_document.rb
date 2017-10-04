class PreRegistrationDocument < ApplicationRecord

  has_attached_file :document
  do_not_validate_attachment_file_type :document

  after_create :read_file_and_create_company

  def read_file_and_create_company
    if Rails.env.development? 
      file_path = self.document.queued_for_write[:original].path
    else
      file_path = self.document.url
    end
    data_file = Spreadsheet.open(file_path)
    worksheet = data_file.worksheet(0)
    unless worksheet.nil?
      worksheet.each_with_index do |data_row, i|
        unless i == 0
          pre_registration = PreRegistration.new
          pre_registration.company_name = data_row.first
          pre_registration.save
        end
      end
    end
  end

  rails_admin do
    edit do
      field :document do
        label "Document"
        partial :pre_registration
      end
    end
  end
end
