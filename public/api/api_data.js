define({ "api": [
  {
    "version": "1.0.0",
    "type": "post",
    "url": "api/v1/trading_parcels/direct_sell",
    "title": "",
    "name": "direct_sell",
    "group": "TradingParcels",
    "description": "<p>direct sell with buyer</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example1:",
          "content": " {\n  \"trading_parcel\":\n    {\n    \"description\":\"Z -7+5T\",\n    \"my_transaction_attributes\":\n                               {\n                                 \"buyer_id\":\"3600\",\n                                 \"paid\":false,\n                                 \"created_at\":\"04/12/2018\"\n                               },\n     \"no_of_stones\":10,\n     \"carats\":1.0,\n     \"credit_period\":20,\n     \"price\":2200.0,\n     \"company\":\"SafeTrade\",\n     \"cost\":2000.0,\n     \"sight\":\"12/2018\",\n     \"source\":\"DTC\",\n     \"percent\":10.0,\n     \"comment\":\"\",\n     \"total_value\":2200.0\n\n    }\n}",
          "type": "json"
        },
        {
          "title": "Request-Example2:",
          "content": " {\n  \"trading_parcel\":\n    {\n    \"description\":\"Z -7+5T\",\n    \"my_transaction_attributes\":\n                               {\n                                 \"buyer_id\":\"3600\",\n                                 \"paid\":false,\n                                 \"created_at\":\"04/12/2018\"\n                               },\n     \"no_of_stones\":10,\n     \"carats\":1.0,\n     \"credit_period\":20,\n     \"price\":2200.0,\n     \"company\":\"SafeTrade\",\n     \"cost\":2000.0,\n     \"sight\":\"12/2018\",\n     \"source\":\"DTC\",\n     \"percent\":10.0,\n     \"comment\":\"\",\n     \"total_value\":2200.0\n\n    },\n    \"over_credit_limit\" : true,\n    \"overdue_days_limit\" : true\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse1:",
          "content": "[\n {\n   \"success\": false,\n   \"details\": {\n       \"id\": 706,\n       \"invoices_overdue\": 0,\n       \"paid_date\": null,\n       \"buyer_id\": 3600,\n       \"seller_id\": 7188,\n       \"outstandings\": 0,\n       \"overdue_amount\": 0,\n       \"last_bought_on\": \"2018-11-24\",\n       \"buyer_percentage\": 0,\n       \"system_percentage\": 6,\n       \"supplier_connected\": 1,\n       \"credit_limit\": true,\n       \"overdue_limit\": false\n   }\n }\n]",
          "type": "json"
        },
        {
          "title": "SuccessResponse2:",
          "content": "[\n {\n   \"success\": true,\n   \"notice\": \"Transaction added successfully\"\n }\n]",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/trading_parcels_controller.rb",
    "groupTitle": "TradingParcels"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "api/v1/secure_center?id=buyer_id",
    "title": "",
    "name": "live_monitoring",
    "group": "companies_controller",
    "description": "<p>get secure center data for buyer</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n  \"success\": true,\n  \"details\": {\n      \"id\": 245,\n      \"invoices_overdue\": 0,\n      \"paid_date\": null,\n      \"buyer_id\": 7177,\n      \"seller_id\": 7187,\n      \"outstandings\": \"0.0\",\n      \"overdue_amount\": \"0.0\",\n      \"last_bought_on\": null,\n      \"buyer_percentage\": \"0.0\",\n      \"system_percentage\": \"0.0\",\n      \"supplier_connected\": 0\n  }\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/companies_controller.rb",
    "groupTitle": "companies_controller",
    "sampleRequest": [
      {
        "url": "https://safetrade.aiapi/v1/secure_center?id=buyer_id"
      }
    ]
  }
] });