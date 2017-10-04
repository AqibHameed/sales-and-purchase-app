module DocumentUrl

  extend ActiveSupport::Concern

  def document_url(document)
    if Rails.env.development?
      document.path
    else
      document.url
    end
  end
end