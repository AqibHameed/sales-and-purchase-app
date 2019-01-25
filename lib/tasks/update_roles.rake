namespace :update do
  task :roles => :environment do
    Customer.all.each do |customer|
      if customer.has_role?('Trader')
        if customer.customer_roles.first.role.present? && customer.customer_roles.first.role.name == 'Buyer'
          customer.customer_roles.first.destory
        end
      end
    end
  end
end
