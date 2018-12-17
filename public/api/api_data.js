define({ "api": [
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/limits/add_limits",
    "title": "",
    "name": "add_limits",
    "group": "Limits",
    "description": "<p>add limits</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": " {\n  {\n  \"buyer_id\": 1,\n  \"limit\": 35000\n  }\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "[\n {\n   \"success\": true,\n   \"message\": \"Limits updated.\"\n }\n]",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/limits_controller.rb",
    "groupTitle": "Limits"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/limits/add_overdue_limit",
    "title": "",
    "name": "add_overdue_limit",
    "group": "Limits",
    "description": "<p>add overdue limits</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": " {\n  {\n  \"buyer_id\": 1,\n  \"limit\": 30\n  }\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "[\n {\n   \"success\": true,\n   \"message\": \"Days Limit updated.\",\n   \"value\": \"30 days\"\n }\n]",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/limits_controller.rb",
    "groupTitle": "Limits"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/proposals/:id/negotiate",
    "title": "",
    "name": "negotiate",
    "group": "Negotiations",
    "description": "<p>negotiation between the buyer and seller</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example1:",
          "content": " {\n  {\n  \"price\":\"200.0\",\n  \"credit\":\"60\",\n  \"comment\":\"\",\n  \"total_value\":\"11000.0\",\n  \"percent\":\"0.0\",\n  \"id\": 58\n  }\n}",
          "type": "json"
        },
        {
          "title": "Request-Example2:",
          "content": " {\n  {\n  \"price\":\"200.0\",\n  \"credit\":\"60\",\n  \"comment\":\"\",\n  \"total_value\":\"11000.0\",\n  \"percent\":\"0.0\",\n  \"confirm\": true,\n  \"id\": 58\n  }\n}",
          "type": "json"
        },
        {
          "title": "Request-Example3:",
          "content": " {\n  {\n  \"price\":\"150.0\",\n  \"credit\":\"60\",\n  \"comment\":\"\",\n  \"total_value\":\"1000.0\",\n  \"percent\":\"0.0\",\n  \"confirm\": true,\n  \"negotiation_id\":89,\n  \"id\": 58\n  }\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse1:",
          "content": "[\n {\n   \"success\": false,\n   \"details\": {\n       \"id\": 248,\n       \"invoices_overdue\": 2,\n       \"paid_date\": \"2018-12-12\",\n       \"buyer_id\": 3,\n       \"seller_id\": 8,\n       \"last_bought_on\": \"2018-12-12\",\n       \"supplier_connected\": 3,\n       \"credit_limit\": true,\n       \"overdue_limit\": false,\n       \"overdue_amount\": 0,\n       \"outstandings\": 0,\n       \"buyer_percentage\": 50,\n       \"system_percentage\": 43\n   }\n }\n]",
          "type": "json"
        },
        {
          "title": "SuccessResponse2:",
          "content": "[\n {\n   \"success\": true,\n   \"message\": \" Proposal is negotiated successfully. \",\n   \"proposal\": {\n       \"status\": \"negotiated\",\n       \"supplier_name\": \"Dummy Seller 1\",\n       \"source\": \"RUSSIAN\",\n       \"description\": \"+11 CLIV/MB LIGHT\",\n       \"sight\": \"12/18\",\n       \"no_of_stones\": 10,\n       \"carats\": \"1.0\",\n       \"cost\": 3000,\n       \"list_percentage\": 10,\n       \"list_avg_price\": 3300,\n       \"list_total_price\": 3300,\n       \"list_credit\": 10,\n       \"list_discount\": 0,\n       \"list_comment\": \"\",\n       \"offered_percent\": 10,\n       \"offered_price\": 3300,\n       \"offered_credit\": 10,\n       \"offered_total_value\": 3300,\n       \"offered_comment\": \"\",\n       \"negotiated\": {\n           \"id\": 88,\n           \"offered_percent\": 0,\n           \"offered_price\": 200,\n           \"offered_total_value\": 11000,\n           \"offered_credit\": 60,\n           \"offered_comment\": \"\",\n           \"offered_from\": \"Dummy Seller 1(seller)\",\n           \"is_mine\": true\n       },\n       \"total_negotiations\": 2,\n       \"negotiations\": [\n           {\n               \"id\": 87,\n               \"offered_percent\": 10,\n               \"offered_credit\": 10,\n               \"offered_price\": 3300,\n               \"offered_total_value\": 3300,\n               \"offered_comment\": \"\",\n               \"offered_from\": \"Buyer C(buyer)\",\n               \"is_mine\": true\n           },\n           {\n               \"id\": 88,\n               \"offered_percent\": 0,\n               \"offered_credit\": 60,\n               \"offered_price\": 200,\n               \"offered_total_value\": 11000,\n               \"offered_comment\": \"\",\n               \"offered_from\": \"Dummy Seller 1(seller)\",\n               \"is_mine\": true\n           }\n       ]\n   },\n   \"response_code\": 200\n }\n]",
          "type": "json"
        },
        {
          "title": "SuccessResponse3:",
          "content": "[\n {\n   \"success\": true,\n   \"message\": \" Negotiation is updated successfully. \",\n   \"negotiation\": {\n       \"from\": \"buyer\",\n       \"proposal_id\": 58,\n       \"id\": 89,\n       \"price\": 150,\n       \"credit\": 60,\n       \"total_value\": 1000,\n       \"percent\": 0,\n       \"comment\": \"\",\n       \"created_at\": \"2018-12-13T17:22:41.000Z\",\n       \"updated_at\": \"2018-12-13T17:24:39.000Z\"\n   },\n   \"response_code\": 200\n }\n]",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/proposals_controller.rb",
    "groupTitle": "Negotiations"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/proposals/3",
    "title": "",
    "name": "create",
    "group": "Proposal",
    "description": "<p>buyer send or update proposal</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example1:",
          "content": "{\n\"trading_parcel_id\" : \"3\",\n\"credit\" : \"2000\",\n\"price\" : \"4500\",\n\"total_value\" : \"4000\"\n}",
          "type": "json"
        },
        {
          "title": "Request-Example2:",
          "content": "{\n\"id\" : \"3\",\n\"credit\" : \"2000\",\n\"price\" : \"5000\",\n\"total_value\" : \"500000\"\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse1:",
          "content": "{\n    \"success\": true,\n    \"message\": \"Proposal Submitted Successfully\"\n}",
          "type": "json"
        },
        {
          "title": "SuccessResponse2:",
          "content": "{\n    \"success\": true,\n    \"message\": \"Proposal Updated Successfully\"\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/proposals_controller.rb",
    "groupTitle": "Proposal"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/trading_parcels/direct_sell",
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
    "url": "/api/v1/secure_center?id=2",
    "title": "",
    "name": "live_monitoring",
    "group": "companies_controller",
    "description": "<p>get secure center data for buyer</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": " {\n    \"success\": true,\n    \"details\": {\n        \"id\": 273,\n        \"invoices_overdue\": 0,\n        \"paid_date\": null,\n        \"buyer_id\": 2,\n        \"seller_id\": 1,\n        \"last_bought_on\": null,\n        \"supplier_connected\": 0,\n        \"overdue_amount\": 0,\n        \"outstandings\": 0,\n        \"buyer_percentage\": 0,\n        \"system_percentage\": 5\n    }\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/companies_controller.rb",
    "groupTitle": "companies_controller",
    "sampleRequest": [
      {
        "url": "https://safetrade.ai/api/v1/secure_center?id=2"
      }
    ]
  }
] });
