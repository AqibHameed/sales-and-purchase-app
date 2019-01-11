class Api::V1::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:device_token, :supplier_notification, :email_attachment, :update_chat_id]
  before_action :current_customer, only: [:device_token, :supplier_notification, :update_chat_id, :customer_list]
  helper_method :current_company

  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper
  include ApplicationHelper
  include CustomersHelper

  respond_to :json


  def current_customer
     token = request.headers['Authorization'].presence
     if token
       @current_customer ||= Customer.find_by_authentication_token(token)
     end
  end
  

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/app_versions
 @apiSampleRequest off
 @apiName app versions
 @apiGroup Api
 @apiDescription buyer send or update proposal
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "versions": []
}
=end
=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/app_versions?version=1.2
 @apiSampleRequest off
 @apiName app versions version = 1.2
 @apiGroup Api
 @apiDescription search app verions with version
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "version": {
        "version": "1.2",
        "force_upgrade": true,
        "recommend_upgrade": true
    }
}
=end

  def app_versions
    if params[:version].present?
      version = AppVersion.where(version: params[:version]).first
      if version.present?
        render json: { success: true, version: version.as_json(except: [:id, :created_at, :updated_at])}
      else
        render json: { success: false, message: "This version does not exist" }
      end
    else
      versions = AppVersion.all
      render json: { success: true, versions: versions.as_json(except: [:id, :created_at, :updated_at])}
    end
  end

  # def tender_by_months
  #   months = Tender.group("month(open_date)").count
  #   data = []
  #   months.each do |month|
  #     data << { month: month[0], tender_count: month[1] }
  #   end
  #   render json: { data: data }
  # end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/filter_data
 @apiSampleRequest off
 @apiName filter_data
 @apiGroup Api
 @apiDescription Filter data
 @apiSuccessExample {json} SuccessResponse:
{
    "suppliers": [
        {
            "id": 1,
            "name": "umair"
        },
        {
            "id": 2,
            "name": "Khuram"
        }
    ],
    "months": [],
    "location": [],
    "response_code": 200
}
=end

  def filter_data
    suppliers = Supplier.all.map { |e| { id: e.id, name: e.name}  }
    months = Tender.group("month(open_date)").count
    countries = Tender.group("country").count
    data = []
    data_countries = []
    countries.each do |country|
      unless country[0].nil? || country[0].blank?
        data_countries << { name: country[0], tender_count: country[1] }
      end
    end
    months.each do |month|
      data << { month: month[0], tender_count: month[1] }
    end
    render json: { suppliers: suppliers, months: data, location: data_countries, response_code: 200  }
  end

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/device_token
 @apiSampleRequest off
 @apiName Device Token
 @apiGroup Api
 @apiDescription Token for devise
 @apiParamExample {json} Request-Example:
 {
"customer":
	{
	"token":"qwe34234werwe32we3",
	"device_type":"ios/android"
	}
}
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "device_token": "qwe34234werwe32we3",
    "type": "ios/android",
    "response_code": 200
}
=end

  def device_token
    if current_customer
      if params[:customer][:token].present?
        device = Device.new(device_params)
        device.customer_id = current_customer.id
        if device.save
          render json: {success: true, device_token: device.token, type: device.device_type, response_code: 200 }
        else
          render json: {success: false, message: device.errors.full_messages, response_code: 201 }
        end
      else
        render json: {success: false, message: 'Please use correct parameter', response_code: 201 }
      end
    else
      render json: { errors: "Not authenticated", response_code: 201 }, status: :unauthorized
    end
  end

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/supplier_notification
 @apiSampleRequest off
 @apiName Supplier notifications
 @apiGroup Api
 @apiDescription Get supplier notifications
 @apiParamExample {json} Request-Example:
{
"supplier_id": 1 ,
"notify": true
 }
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "supplier_notification": {
        "supplier_id": 1,
        "notify": true
    },
    "response_code": 200
}
=end

  def supplier_notification
    if current_customer
      supplier_notification = SupplierNotification.where(customer_id: current_customer.id, supplier_id: params[:supplier_id]).first_or_initialize
      supplier_notification.notify = params[:notify]
      if supplier_notification.save
        render json: {success: true, supplier_notification: supplier_notification.as_json(only: [:supplier_id, :notify]), response_code: 200 }
      else
        render json: {success: false, errors: supplier_notification.errors.full_messages, response_code: 201 }
      end
    else
      render json: { errors: "Not authenticated", response_code: 201 }, status: :unauthorized
    end
  end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/suppliers
 @apiSampleRequest off
 @apiName get suppliers
 @apiGroup Api
 @apiDescription get liist of suppliers
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "supplier_notifications": [
        {
            "supplier_id": 1,
            "supplier_name": "ali",
            "is_notified": true
        },
        {
            "supplier_id": 2,
            "supplier_name": "aqib",
            "is_notified": false
        }
    ],
    "response_code": 200
}
=end

  def get_suppliers
    if current_customer
      companies = Supplier.all
      render json: { success: true, supplier_notifications: suppliers_data(companies, current_customer), response_code: 200 }
    else
      render json: { errors: "Not authenticated", response_code: 201 }, status: :unauthorized
    end
  end

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/attachment
 @apiSampleRequest off
 @apiName email attachment
 @apiGroup Api
 @apiDescription direct sell with buyer
 @apiParamExample {json} Request-Example:
{
"email_attachment":
{
	"file":"<file object>",
	"tender_id": 1
}
}
 @apiSuccessExample {json} SuccessResponse:
{
need to check
}
=end


  def email_attachment
    if current_customer
      attachment = EmailAttachment.new(attachment_params)
      attachment.customer_id = current_customer.id
      if attachment.save
        # need to send an email to admin
        TenderMailer.send_attachment_to_admin(attachment, attachment.customer).deliver
        render json: { success: true, attachment: attachment, response_code: 200 }
      else
        render json: {success: false, message: attachment.errors.full_messages, response_code: 201 }
      end
    else
      render json: { errors: "Not authenticated", response_code: 201 }, status: :unauthorized
    end
  end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/customer_list
 @apiSampleRequest off
 @apiName customer list
 @apiGroup Api
 @apiDescription get list of customer
 @apiSuccessExample {json} SuccessResponse:
{
    "pagination": {
        "total_pages": 1,
        "prev_page": null,
        "next_page": null,
        "current_page": 1
    },
    "customers": [
        {
            "id": 5,
            "first_name": "abc",
            "last_name": "def",
            "email": "wetu@getnada.com",
            "company": "Dummy co. 3",
            "chat_id": "-1"
        },
        {
            "id": 3,
            "first_name": "abc",
            "last_name": "xyz",
            "email": "xabi@nada.email",
            "company": "Dummy co. 2",
            "chat_id": "-1"
        }
    ],
    "response_code": 200
}
=end

  def customer_list
    @customers = Customer.all
    if params[:company].present?
      c = Company.where('name LIKE ?', "%#{params[:company]}%").first
      @customers = c.customers
    end
    @customers = @customers.where('first_name LIKE ?', "%#{params[:first_name]}%") if params[:first_name].present?
    @customers = @customers.where('last_name LIKE ?', "%#{params[:last_name]}%") if params[:last_name].present?
    @customers = @customers.where('first_name LIKE ? or last_name LIKE ?', "%#{params[:name]}%", "%#{params[:name]}%") if params[:name].present?
    @customers = @customers.page(params[:page]).per(params[:count])
    render json: { pagination: set_pagination(:customers), customers: get_customers_data(@customers, current_customer), response_code: 200 }
  end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/company_list
 @apiSampleRequest off
 @apiName company list
 @apiGroup Api
 @apiDescription Show list of companies
 @apiSuccessExample {json} SuccessResponse:
{
    "pagination": {
        "total_pages": 144,
        "prev_page": null,
        "next_page": null,
        "current_page": 1
    },
    "companies": [
        {
            "id": "1",
            "name": "Dummy co. 1",
            "city": null,
            "country": "India",
            "created_at": "2018-10-25T11:21:17.000Z",
            "updated_at": "2018-10-25T11:21:17.000Z",
            "purchases_completed": 3590,
            "suppliers_connected": 1,
            "status": false,
            "customers": []
        },
        {
            "id": "2",
            "name": "Dummy co. 2",
            "city": null,
            "country": "India",
            "created_at": "2018-10-25T11:21:17.000Z",
            "updated_at": "2018-10-25T11:21:17.000Z",
            "purchases_completed": 0,
            "suppliers_connected": 2,
            "status": true,
            "customers": [
                {
                    "id": 3,
                    "first_name": "abc",
                    "last_name": "xyz"
                }
            ]
        }
    ],
    "response_code": 200
}
=end

  def company_list
    # @companies = Company.all
    if current_company
      if params[:name].present?
        company = Company.where('name LIKE ?', "#{params[:name]}%").where.not(id: current_company.id)
        any_where = Company.where('name LIKE ?', "%#{params[:name]}%").where.not(id: current_company.id)
        company = (company + any_where).uniq
      else
        company = Company.where.not(id: current_company.id)
      end
      @companies = Kaminari.paginate_array(company).page(params[:page]).per(params[:count])
      render json: { pagination: set_pagination(:companies), companies: companies_data(@companies), response_code: 200 }
    else
      render json: { errors: "Not authenticated", response_code: 201 }, status: :unauthorized
    end
  end

=begin
 @apiVersion 1.0.0
 @api {put} /api/v1/update_chat_id
 @apiSampleRequest off
 @apiName dupdate chat id
 @apiGroup Api
 @apiDescription update authorized chat id
 @apiParamExample {json} Request-Example:
{
	"chat_id": "43AESdca43"
}
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "customer": {
        "chat_id": "43AESdca43",
        "email": "ranu.ongraph@gmail.com",
        "first_name": "test",
        "last_name": "test"
    },
    "response_code": 200
}
=end

  def update_chat_id
    if current_customer
      current_customer.chat_id = params[:chat_id]
      current_customer.save(validate: false)
      render json: {success: true, customer: current_customer.as_json(only: [:first_name, :last_name, :email, :company, :chat_id]), response_code: 200 }
    else
      render json: { errors: "Not authenticated", response_code: 201 }, status: :unauthorized
    end
  end

  def set_pagination(name, options = {})
    results = instance_variable_get("@#{name}")
    page = {}
    pagination = {}
    if results.current_page <= results.total_pages
      request_params = request.query_parameters
      url_without_params = request.original_url.slice(0..(request.original_url.index("?")-1)) unless request_params.empty?
      url_without_params ||= request.original_url
      page[:first] = 1 if results.total_pages > 1 && !results.first_page?
      page[:last]  = results.total_pages  if results.total_pages > 1 && !results.last_page?
      page[:next]  = results.current_page + 1 unless results.last_page?
      page[:prev]  = results.current_page - 1 unless results.first_page?
      page.each do |k, v|
        page[k] = "#{url_without_params}?page=#{v}#{url_params}"
      end
      pagination = {
        total_pages: results.total_pages,
        prev_page: page[:prev].present? ? page[:prev].to_s : nil,
        next_page: page[:next].present? ? page[:next].to_s : nil,
        current_page: results.current_page
      }
    end
  end

  def url_params
    url = request.url
    uri = URI(url)
    params = CGI.parse(uri.query || "")
    params.delete('page')
    uri.query = URI.encode_www_form(params)
    query = ''
    query = '&'+uri.query unless uri.query.blank?
  end

  def get_trading_pracels source, description, parcel_id
    if parcel_id
      TradingParcel.find parcel_id
    elsif source and description
      TradingParcel.where(sold: false).where("description LIKE ? AND source=? ", description, source)
    elsif source
      TradingParcel.where(sold: false).where(source: source)
    elsif description
      TradingParcel.where(sold: false).where("description LIKE ?", description)
    else
      TradingParcel.where(sold: false)
    end
  end


  def calculate_sales

    zero = {
        term: "cash",
        percent: sale_count_value('0', @credit_given_transaction.count, 'count', current_company),
        pending_transaction: sale_count_value('0', @total_pending_sent, 'pending', current_company),
        overdue_transaction: sale_count_value('0', @total_overdue_sent, 'overdue', current_company),
        complete_transaction: sale_count_value('0', @total_complete_sent, 'complete', current_company)

    }


    one = {
        term: "1<=30",
        percent: sale_count_value('less_30', @credit_given_transaction.count, 'count', current_company),
        pending_transaction: sale_count_value('less_30', @total_pending_sent, 'pending', current_company),
        overdue_transaction: sale_count_value('less_30', @total_overdue_sent, 'overdue', current_company),
        complete_transaction: sale_count_value('less_30', @total_complete_sent, 'complete', current_company)

    }

    two = {
        term: "61<=90",
        percent: sale_count_value('90', @credit_given_transaction.count, 'count', current_company),
        pending_transaction: sale_count_value('90', @total_pending_sent, 'pending', current_company),
        overdue_transaction: sale_count_value('90', @total_overdue_sent, 'overdue', current_company),
        complete_transaction: sale_count_value('90', @total_complete_sent, 'complete', current_company)

    }

    three = {
        term: "91",
        percent: sale_count_value('more_90', @credit_given_transaction.count, 'count', current_company),
        pending_transaction: sale_count_value('more_90', @total_pending_sent, 'pending', current_company),
        overdue_transaction: sale_count_value('more_90', @total_overdue_sent, 'overdue', current_company),
        complete_transaction: sale_count_value('more_90', @total_complete_sent, 'complete', current_company)

    }


    total = {
        term: "total",
        percent: @credit_given_transaction.count,
        pending_transaction: @total_pending_sent,
        overdue_transaction: @total_overdue_sent,
        complete_transaction: @total_complete_sent
    }


    {"0": zero, "1": one, "2": two, "3": three, "4": total}

  end


  protected

  def current_company
    @company ||= current_customer.company unless current_customer.nil?
  end

  private

  def device_params
    params.require(:customer).permit(:token, :device_type)
  end

  def suppliers_data(suppliers, customer)
    @data = []
    suppliers.each do |supplier|
      @data << {
        supplier_id: supplier.id,
        supplier_name: supplier.name,
        is_notified: customer.notify_by_supplier(supplier)
      }
    end
    @data
  end

  def get_customers_data(customers, current_customer)
    @data = []
    customers.each do |c|
      unless c.id == current_customer.id
        @data << {
          id: c.id,
          first_name: c.first_name,
          last_name: c.last_name,
          email: c.email,
          company: c.company.try(:name),
          chat_id: c.chat_id
        }
      end
    end
    @data
  end

  def companies_data(companies)
    @data = []
    companies.each do |c|
      customers = []
      c.customers.each do |customer|
        customers << {
          id: customer.id,
          first_name: customer.first_name,
          last_name: customer.last_name
        }
      end
      status = c.customers.present?
      @data << {
        id: c.id.to_s,
        name: c.name,
        city: c.city,
        country: c.county,
        created_at: c.created_at,
        updated_at: c.updated_at,
        purchases_completed: get_completed_transaction(c),
        suppliers_connected: get_supplier_connected(c.id),
        status: status,
        customers: customers
      }
    end
    @data
  end

  def attachment_params
    params.require(:email_attachment).permit(:file,:tender_id)
  end

  def get_supplier_connected(buyer)
    count = CreditLimit.where("buyer_id =?", buyer).count
  end

  def get_completed_transaction(company)
    @transactions = Transaction.includes(:trading_parcel).where('(buyer_id = ? or seller_id = ?) and paid = ?',company.id, company.id, true)
    return @transactions.count
  end

end
