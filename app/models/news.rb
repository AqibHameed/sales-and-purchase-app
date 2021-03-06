class News < ApplicationRecord

  attr_accessible :title, :url, :date, :category, :description, :status

  rails_admin do
    list do
      [:title, :url, :category, :description].each do |field_name|
        field field_name
      end
      field :date do
         strftime_format "%Y-%m-%d"
      end
      field :status, :toggle
    end
    edit do
      field :title
      field :url
      field :date do
        default_value Date.current
      end
      field :category, :enum do
        default_value 'News'
        enum do
          ['News', 'Event']
        end
      end
      field :description, :wysihtml5

      field :status do
        default_value true
      end
    end
  end

end

