require 'rails_helper'
RSpec.describe Api::V1::TradingParcelsController do
  before(:all) do
    create_roles
    @unregister_company = Company.create(name: Faker::Name.name)
    @customer = create_customer
    @buyer = create_buyer

    @parcel = create(:trading_parcel, customer: @customer, company: @customer.company)
    @demand_supplier = create(:demand_supplier)
    @demand = create(:demand, description:@parcel.description, company_id: @buyer.company.id)
  end

  before(:each) do
    request.headers.merge!(authorization: @customer.authentication_token)
  end

  describe '#create' do
    context 'when seller create trading parcel' do
      it 'does create parcel' do
        post :create, params: {trading_parcel: {source: 'SPECIAL',
                                                description: '5-10 Cts BLK CLIV WHITE',
                                                credit_period: '2000',
                                                no_of_stones: '10',
                                                total_value: 5000.0,
                                                percent: '10',
                                                cost: 2500.0,
                                                avg_price: 2000.0,
                                                carats: 1,
                                                comment: '',
                                                discout: '',
                                                sight: '',
                                                lot_no: ''}}
        response.body.should have_content('Parcel created successfully')
        expect(response.status).to eq(200)
        expect(response.message).to eq("OK")
        expect(response.success?).to eq(true)
      end
    end

    context 'when seller send unknown params' do
      it 'does show error' do
        post :create, params: {trading_parcel: {source: 'SPECIAL',
                                                description: '5-10 Cts BLK CLIV WHITE',
                                                credit_period: '2000',
                                                no_of_stones: '10',
                                                discout: '',
                                                sight: '',
                                                lot_no: ''}}

        response.body.should have_content('errors')
      end
    end

    context 'when seller send nonexitsting company' do
      it 'does show error' do
        request.headers.merge!(authorization: 'adjkasdkjasdnjkasnd')
        post :create, params: {trading_parcel: {source: 'SPECIAL',
                                                description: '5-10 Cts BLK CLIV WHITE',
                                                credit_period: '2000',
                                                no_of_stones: '10',
                                                carats: 1,
                                                comment: '',
                                                discout: '',
                                                sight: '',
                                                lot_no: ''}}
        response.body.should have_content('Not authenticated')
      end
    end
  end

  describe '#update' do
    context 'when seller update trading parcel' do
      it 'does update the related parcel' do
        post :update, params: {id: @parcel.id, trading_parcel: {source: 'SPECIAL',
                                                                description: '5-10 Cts BLK CLIV WHITE',
                                                                credit_period: '2000',
                                                                no_of_stones: '10',
                                                                total_value: 5000.0,
                                                                percent: '10',
                                                                cost: 2500.0,
                                                                avg_price: 2000.0,
                                                                carats: 1,
                                                                comment: '',
                                                                discout: '',
                                                                sight: '',
                                                                lot_no: ''}}
        response.body.should have_content('Parcel updated successfully')
        expect(response.status).to eq(200)
        expect(response.message).to eq("OK")
        expect(response.success?).to eq(true)
      end
    end
    context 'when seller update trading parcel with wrong params' do
      it 'does show error' do
        post :update, params: {id: @parcel.id, trading_parcel: {source: 'SPECIAL',
                                                                description: '5-10 Cts BLK CLIV WHITE',
                                                                credit_period: '2000',
                                                                no_of_stones: '10',
                                                                carats: 1,
                                                                comment: '',
                                                                discout: '',
                                                                sight: '',
                                                                lot_no: ''}}
        response.body.should have_content('errors')
      end
    end

    context 'when seller update trading parcel with unauthentication' do
      it 'does show error' do
        request.headers.merge!(authorization: 'aksjdjkasjdnkjsadnkjasndkjas')
        post :update, params: {id: @parcel.id, trading_parcel: {source: 'SPECIAL',
                                                                description: '5-10 Cts BLK CLIV WHITE',
                                                                credit_period: '2000',
                                                                no_of_stones: '10',
                                                                total_value: 5000.0,
                                                                percent: '10',
                                                                cost: 2500.0,
                                                                avg_price: 2000.0,
                                                                carats: 1,
                                                                comment: '',
                                                                discout: '',
                                                                sight: '',
                                                                lot_no: ''}}
        response.body.should have_content('Not authenticated')
      end
    end

  end

  describe '#show' do
    context 'when seller want to see any single trading parcel' do
      it 'does show the related parcel' do
        @buyer_score = BuyerScore.create(company_id:@buyer.company.id ,rank:5)
        get :show, params: {id: @parcel.id}
        response.body.should have_content(@parcel.id)
        JSON.parse(response.body)["parcel"]["vital_sales_data"]["demanded_clients"].first["rank"].present?
        expect(response.status).to eq(200)
        expect(response.message).to eq("OK")
        expect(response.success?).to eq(true)
      end
    end
    context 'when seller send unknow id' do
      it 'does show parcel not found' do
        get :show, params: {id: 22}
        response.body.should have_content('Parcel not found')
      end
    end
    context 'when unauthenticated seller want to see any single trading parcel' do
      it 'does show not authenticated' do
        request.headers.merge!(authorization: 'aksjdjkasjdnkjsadnkjasndkjas')
        get :show, params: {id: @parcel.id}
        response.body.should have_content('Not authenticated')
      end
    end
  end

  describe '#direct_sell' do
    context 'when trader do direct_sell on credit' do
      it 'does sold successfully' do
        request.content_type = 'application/json'
        post :direct_sell, params: {
            trading_parcel: {
                description: 'Z -7+5T',
                activity: 'sell',
                my_transaction_attributes: {
                    company_id: "#{@buyer.company_id}",
                    paid: false,
                    created_at: '04/12/2018'
                },
                no_of_stones: 10,
                carats: 1,
                credit_period: 20,
                price: 2200,
                company: 'SafeTrade',
                cost: 2000,
                sight: '12/2018',
                source: 'DTC',
                percent: 10,
                comment: '',
                total_value: 2200
            },
            over_credit_limit: true,
            overdue_days_limit: true
        }
        transaction = Transaction.last
        expect(transaction.transaction_type).to eq('manual')
        expect(transaction.seller_id).to eq(@customer.company_id)
        expect(transaction.buyer_id).to eq(@buyer.company_id)
        expect(transaction.paid).to be false
      end
    end

    context 'when seller do direct_buy on credit' do
      it 'does sold successfully' do
        request.content_type = 'application/json'
        post :direct_sell, params: {
            trading_parcel: {
                description: 'Z -7+5T',
                activity: 'buy',
                my_transaction_attributes: {
                    company_id: "#{@buyer.company_id}",
                    paid: false,
                    created_at: '04/12/2018'
                },
                no_of_stones: 10,
                carats: 1,
                credit_period: 20,
                price: 2200,
                company: 'SafeTrade',
                cost: 2000,
                sight: '12/2018',
                source: 'DTC',
                percent: 10,
                comment: '',
                total_value: 2200
            },
            over_credit_limit: true,
            overdue_days_limit: true
        }
        transaction = Transaction.last
        expect(transaction.transaction_type).to eq('manual')
        expect(transaction.buyer_id).to eq(@customer.company_id)
        expect(transaction.seller_id).to eq(@buyer.company_id)
        expect(transaction.paid).to be false
      end
    end

    context 'when seller do direct_sell on unregistered buyer' do
      it 'does sold successfully' do
        request.content_type = 'application/json'
        post :direct_sell, params: {
            trading_parcel: {
                description: 'Z -7+5T',
                activity: 'sell',
                my_transaction_attributes: {
                    company_id: "#{@unregister_company.id}",
                    paid: true,
                    created_at: '04/12/2018'
                },
                no_of_stones: 10,
                carats: 1,
                credit_period: 20,
                price: 2200,
                company: 'SafeTrade',
                cost: 2000,
                sight: '12/2018',
                source: 'DTC',
                percent: 10,
                comment: '',
                total_value: 2200
            },
            over_credit_limit: true,
            overdue_days_limit: true
        }
        response.body.should have_content('Transaction added successfully')
      end
    end

    context 'when seller do direct_sell on unregistered buyer' do
      it 'does sold successfully' do
        request.content_type = 'application/json'
        post :direct_sell, params: {
            trading_parcel: {
                description: 'Z -7+5T',
                activity: 'buy',
                my_transaction_attributes: {
                    company_id: "#{@unregister_company.id}",
                    paid: false,
                    created_at: '04/12/2018'
                },
                no_of_stones: 10,
                carats: 1,
                credit_period: 20,
                price: 2200,
                company: 'SafeTrade',
                cost: 2000,
                sight: '12/2018',
                source: 'DTC',
                percent: 10,
                comment: '',
                total_value: 2200
            }
        }
        response.body.should have_content('Transaction added successfully')
      end
    end

    context 'when seller do direct_sell on unregistered buyer with company info' do
      it 'show warning to the seller' do
        request.content_type = 'application/json'
        post :direct_sell, params: {
            trading_parcel: {
                description: 'Z -7+5T',
                activity: 'buy',
                my_transaction_attributes: {
                    company_id: "#{@unregister_company.id}",
                    paid: false
                },
                no_of_stones: 10,
                carats: 1,
                credit_period: 20,
                price: 2200,
                company: 'SafeTrade',
                cost: 2000,
                sight: '12/2018',
                source: 'DTC',
                percent: 10,
                comment: '',
                total_value: 2200,
                check_transactions: true
            }
        }
        response.body.should have_content('No Information Available about this Company. Do you want to continue ?')
      end
    end

    context 'when unauthenticated seller do direct_sell' do
      it 'does sold Not authenticated ' do
        request.headers.merge!(authorization: 'unkown token')
        request.content_type = 'application/json'
        post :direct_sell, params: {
            trading_parcel: {
                description: 'Z -7+5T',
                activity: 'sell',
                my_transaction_attributes: {
                    company_id: "#{@buyer.id}",
                    paid: false
                },
                no_of_stones: 10,
                carats: 1,
                credit_period: 20,
                price: 2200,
                company: 'SafeTrade',
                cost: 2000,
                sight: '12/2018',
                source: 'DTC',
                percent: 10,
                comment: '',
                total_value: 2200
            }
        }
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when seller do direct_sell with unknown company' do
      it 'does sold customer not exist' do
        request.content_type = 'application/json'
        post :direct_sell, params: {
            trading_parcel: {
                description: 'Z -7+5T',
                activity: 'buy',
                my_transaction_attributes: {
                    company_id: "hg",
                    paid: false,
                    created_at: '04/12/2018'
                },
                no_of_stones: 10,
                carats: 1,
                credit_period: 20,
                price: 2200,
                company: 'SafeTrade',
                cost: 2000,
                sight: '12/2018',
                source: 'DTC',
                percent: 10,
                comment: '',
                total_value: 2200
            },
            over_credit_limit: true,
            overdue_days_limit: true
        }
        response.body.should have_content('Customer does not present')
      end
    end

    context 'when buyer do direct_buy on unregistered buyer' do
      it 'does sold successfully' do
        request.headers.merge!(authorization: @buyer.authentication_token)
        request.content_type = 'application/json'
        post :direct_sell, params: {
            trading_parcel: {
                description: 'Z -7+5T',
                activity: 'buy',
                my_transaction_attributes: {
                    company_id: "#{@customer.company_id}",
                    paid: false,
                    created_at: '04/12/2018'
                },
                no_of_stones: 10,
                carats: 1,
                credit_period: 20,
                price: 2200,
                company: 'SafeTrade',
                cost: 2000,
                sight: '12/2018',
                source: 'DTC',
                percent: 10,
                comment: '',
                total_value: 2200
            },
            over_credit_limit: true,
            overdue_days_limit: true
        }
        transaction = Transaction.last
        expect(transaction.transaction_type).to eq('manual')
        expect(transaction.buyer_id).to eq(@buyer.company_id)
        expect(transaction.seller_id).to eq(@customer.company_id)
        expect(transaction.paid).to be false
      end
    end

    context 'when seller do direct_sell with unknown params' do
      it 'does show error of trading parcel' do
        request.content_type = 'application/json'
        post :direct_sell, params: {
            trading_parcel: {
                description: 'Z -7+5T',
                activity: 'sell',
                my_transaction_attributes: {
                    company_id: @buyer.company_id,
                    paid: false
                },
                no_of_stones: 10,
                carats: 1,
                credit_period: 20,
                price: 2200,
                company: 'SafeTrade',
                cost: 2000,
                sight: '12/2018',
                source: 'DTC',
                percent: 10,
                comment: '',
                total_value: 2200
            }
        }
        response.body.should have_content("Invoice date can't be nil.")
      end
    end
  end

  describe '#available_trading_parcels' do
    context 'when unauthorized user to get the list of available parcel' do
      it 'does show error un authorized user' do
        request.headers.merge!(authorization: 'wetasdetoken')
        get :available_trading_parcels
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authorized user to get the list of available parcel' do
      it 'does show the list of available parcel' do
        get :available_trading_parcels
        expect(assigns(:all_parcels).first[:name]).to eq(@demand_supplier.name)
        expect(assigns(:all_parcels).first[:parcels].first[:description]).to eq(@parcel.description)
        response.success?.should be true
      end
    end
  end

  describe '#destroy' do
    context 'when unauthorized user to destroy the trading parcle' do
      it 'does show error un authorized user' do
        request.headers.merge!(authorization: 'wetasdetoken')
        delete :destroy, params: {id: @parcel.id}
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authorized user to destroy the trading parcle and parcel doest not exist' do
      it 'does show Parcel does not exist' do
        delete :destroy, params: {id: 'al'}
        response.body.should have_content('Parcel does not exist.')
      end
    end

    context 'when authorized user to destroy the trading parcle and parcel is exist' do
      it 'does show Parcel does not exist' do
        delete :destroy, params: {id: @parcel.id}
        response.body.should have_content('Your parcel is deleted successfully.')
      end
    end
  end
end