class CustomerSerializer < ActiveModel::Serializer
   attributes :id, :email, :created_at, :updated_at, :first_name, :last_name, :city, :address, :postal_code, :phone, :status, :company, :company_address, :phone_2, :mobile_no, :authentication_token
end 