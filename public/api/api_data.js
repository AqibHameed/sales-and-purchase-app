define({ "api": [
  {
    "version": "1.0.0",
    "type": "post",
    "url": "api/v1/trading_parcels/direct_sell",
    "title": "",
    "name": "direct_sell",
    "group": "DirectSell",
    "description": "<p>direct sell with buyer</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": " {\n  \"trading_parcel\":\n    {\n    \"description\":\"Z -7+5T\",\n    \"my_transaction_attributes\":\n                               {\n                                 \"buyer_id\":\"3600\",\n                                 \"paid\":false,\n                                 \"created_at\":\"04/12/2018\"\n                               },\n     \"no_of_stones\":10,\n     \"carats\":1.0,\n     \"credit_period\":20,\n     \"price\":2200.0,\n     \"company\":\"SafeTrade\",\n     \"cost\":2000.0,\n     \"sight\":\"12/2018\",\n     \"source\":\"DTC\",\n     \"percent\":10.0,\n     \"comment\":\"\",\n     \"total_value\":2200.0\n\n    }\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "[\n {\n   \"success\": false,\n   \"details\": {\n       \"id\": 706,\n       \"invoices_overdue\": 0,\n       \"paid_date\": null,\n       \"buyer_id\": 3600,\n       \"seller_id\": 7188,\n       \"outstandings\": 0,\n       \"overdue_amount\": 0,\n       \"last_bought_on\": \"2018-11-24\",\n       \"buyer_percentage\": 0,\n       \"system_percentage\": 6,\n       \"supplier_connected\": 1,\n       \"credit_limit\": true,\n       \"overdue_limit\": false\n   }\n }\n]",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/trading_parcels_controller.rb",
    "groupTitle": "DirectSell"
  }
] });
