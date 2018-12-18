define({ "api": [
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/device_token",
    "title": "",
    "name": "Device_Token",
    "group": "Api",
    "description": "<p>Token for devise</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": " {\n\"customer\":\n\t{\n\t\"token\":\"qwe34234werwe32we3\",\n\t\"device_type\":\"ios/android\"\n\t}\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"device_token\": \"qwe34234werwe32we3\",\n    \"type\": \"ios/android\",\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/api_controller.rb",
    "groupTitle": "Api"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/supplier_notification",
    "title": "",
    "name": "Supplier_notifications",
    "group": "Api",
    "description": "<p>Get supplier notifications</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n\"supplier_id\": 1 ,\n\"notify\": true\n }",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"supplier_notification\": {\n        \"supplier_id\": 1,\n        \"notify\": true\n    },\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/api_controller.rb",
    "groupTitle": "Api"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/attachment",
    "title": "",
    "name": "email_attachment",
    "group": "Api",
    "description": "<p>direct sell with buyer</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n\"email_attachment\":\n{\n\t\"file\":\"<file object>\",\n\t\"tender_id\": 1\n}\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\nneed to check\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/api_controller.rb",
    "groupTitle": "Api"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/filter_data",
    "title": "",
    "name": "filter_data",
    "group": "Api",
    "description": "<p>Filter data</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse1:",
          "content": "{\n    \"suppliers\": [\n        {\n            \"id\": 1,\n            \"name\": \"umair\"\n        },\n        {\n            \"id\": 2,\n            \"name\": \"Khuram\"\n        }\n    ],\n    \"months\": [],\n    \"location\": [],\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/api_controller.rb",
    "groupTitle": "Api"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/suppliers",
    "title": "",
    "name": "get_suppliers",
    "group": "Api",
    "description": "<p>get liist of suppliers</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse1:",
          "content": "{\n    \"success\": true,\n    \"supplier_notifications\": [\n        {\n            \"supplier_id\": 1,\n            \"supplier_name\": \"ali\",\n            \"is_notified\": true\n        },\n        {\n            \"supplier_id\": 2,\n            \"supplier_name\": \"aqib\",\n            \"is_notified\": false\n        }\n    ],\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/api_controller.rb",
    "groupTitle": "Api"
  },
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
    "url": "/api/v1/signup",
    "title": "",
    "name": "signup",
    "group": "Registeration",
    "description": "<p>Sign up Customer</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n\t\"registration\":\n{\n\t\"email\":\"test@example.com\",\n\t\"password\":\"password\",\n\t\"first_name\": \"first_name\",\n\t\"last_name\":\"last_name\",\n\t\"city\":\"city\",\n\t\"address\": \"address\",\n\t\"postal_code\": \"25612\",\n\t\"phone\": \"256326\",\n\t\"company_id\": \"1\",\n\t\"company_address\": \"company_address\",\n\t\"phone_2\": \"9852523\",\n\t\"mobile_no\": \"985263812\",\n\t\"country_code\": \"91\"\n}\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"message\": \"A request has been to sent to your company admin for approval. You can access your account after approval\",\n    \"customer\": {\n        \"id\": 22,\n        \"email\": \"test@example.com\",\n        \"created_at\": \"2018-12-17T18:38:53.000Z\",\n        \"updated_at\": \"2018-12-17T18:38:56.000Z\",\n        \"first_name\": \"first_name\",\n        \"last_name\": \"last_name\",\n        \"city\": \"city\",\n        \"address\": \"address\",\n        \"postal_code\": \"25612\",\n        \"phone\": \"256326\",\n        \"status\": null,\n        \"company\": \"Buyer A\",\n        \"company_address\": \"company_address\",\n        \"phone_2\": \"9852523\",\n        \"mobile_no\": \"+91 985263812\",\n        \"authentication_token\": \"qeA97FXpxSGfLX49YzMX\",\n        \"chat_id\": \"-1\",\n        \"token\": null\n    },\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/registrations_controller.rb",
    "groupTitle": "Registeration"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/log_in",
    "title": "",
    "name": "login",
    "group": "Session",
    "description": "<p>Login Customer</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n\"customer\": {\n\t\"email\": \"umair.raza101@gmail.com\",\n\t\"password\": \"password\"\n}\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"customer\": {\n        \"id\": 21,\n        \"email\": \"umair.raza101@gmail.com\",\n        \"designation\": \"Buyer/Seller\",\n        \"created_at\": \"2018-12-07T15:00:19.000Z\",\n        \"updated_at\": \"2018-12-17T18:32:41.000Z\",\n        \"first_name\": \"Umair\",\n        \"last_name\": \"Raza\",\n        \"city\": null,\n        \"address\": null,\n        \"postal_code\": null,\n        \"phone\": null,\n        \"status\": null,\n        \"company\": \"Dummy Seller 1\",\n        \"company_address\": null,\n        \"phone_2\": null,\n        \"mobile_no\": \"+1\",\n        \"authentication_token\": \"XwHsMFNtQAy6aFpttQek\",\n        \"chat_id\": \"-1\",\n        \"token\": null\n    },\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/sessions_controller.rb",
    "groupTitle": "Session"
  },
  {
    "version": "1.0.0",
    "type": "delete",
    "url": "/api/v1/log_out",
    "title": "",
    "name": "logout",
    "group": "Session",
    "description": "<p>Logout Customer</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"response_code\": 200\n}}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/sessions_controller.rb",
    "groupTitle": "Session"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/bid_history?parcel_id=1",
    "title": "",
    "name": "last_3_bids",
    "group": "Stones",
    "description": "<p>get bids history on parcel with respect to parcel id</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse1:",
          "content": "{\n    \"errors\": \"Parcel not found\",\n    \"response_code\": 201\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/stones_controller.rb",
    "groupTitle": "Stones"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/parcels/upload",
    "title": "",
    "name": "upload",
    "group": "Stones",
    "description": "<p>Upload image for stone parcels</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n\"parcel_id\": 167 ,\n\"image\": <image_object>\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"message\": 'Image successfully uploaded.',\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/stones_controller.rb",
    "groupTitle": "Stones"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/tender_notifications",
    "title": "",
    "name": "create",
    "group": "TenderNotifications",
    "description": "<p>tender notifications</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\"tender_id\": 1 ,\"notify\": true }",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"tender_notification\": {\n        \"tender_id\": 1,\n        \"notify\": true\n    },\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/tender_notifications_controller.rb",
    "groupTitle": "TenderNotifications"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/tender_notifications/notifications",
    "title": "",
    "name": "notifications",
    "group": "TenderNotifications",
    "description": "<p>Notification history</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse1:",
          "content": "{\n    \"success\": true,\n    \"notifications\": [],\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/tender_notifications_controller.rb",
    "groupTitle": "TenderNotifications"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/tenders/closed",
    "title": "",
    "name": "closed",
    "group": "Tenders",
    "description": "<p>List of closed tenders</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"tenders\": [],\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/tenders_controller.rb",
    "groupTitle": "Tenders"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/find_active_parcels?term=17.37",
    "title": "",
    "name": "find_active_parcels",
    "group": "Tenders",
    "description": "<p>search in active parcels</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse1:",
          "content": "{\n    \"success\": true,\n    \"parcels\": [],\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/tenders_controller.rb",
    "groupTitle": "Tenders"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/old_tenders",
    "title": "",
    "name": "old_tender",
    "group": "Tenders",
    "description": "<p>get old tenders</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"pagination\": {\n        \"total_pages\": 1,\n        \"prev_page\": null,\n        \"next_page\": null,\n        \"current_page\": 1\n    },\n    \"tenders\": [\n        {\n            \"id\": 982,\n            \"name\": \"DEMO \",\n            \"start_date\": \"2018-01-05T13:00:00.000Z\",\n            \"end_date\": \"2018-12-31T12:56:00.000Z\",\n            \"company_name\": \"DEMO\",\n            \"company_logo\": null,\n            \"city\": \"Surat\",\n            \"country\": \"India\",\n            \"notification\": false\n        }\n    ],\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/tenders_controller.rb",
    "groupTitle": "Tenders"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/old_upcoming",
    "title": "",
    "name": "old_upcoming",
    "group": "Tenders",
    "description": "<p>old up coming</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"tenders\": [\n        {\n            \"id\": 1123,\n            \"name\": \"ODC January 2019\",\n            \"start_date\": \"2019-01-20T01:30:00.000Z\",\n            \"end_date\": \"2019-01-30T05:46:00.000Z\",\n            \"company_name\": \"Okavango Diamond Company\",\n            \"company_logo\": null,\n            \"city\": \"Gaborone\",\n            \"country\": \"BW\",\n            \"notification\": false\n        }\n    ],\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/tenders_controller.rb",
    "groupTitle": "Tenders"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/stone_parcel",
    "title": "",
    "name": "stone_parcel",
    "group": "Tenders",
    "description": "<p>Tender's Stone parcel</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": " {\n\"id\": 1 ,\n\"comments\": \"\",\n \"valuation\": \"\",\n \"parcel_rating\": 4\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"errors\": [\n        \"Parcel not found\"\n    ],\n    \"response_code\": 201\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/tenders_controller.rb",
    "groupTitle": "Tenders"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/tender_parcel?tender_id=1",
    "title": "",
    "name": "tender_parcel",
    "group": "Tenders",
    "description": "<p>tender parcels detail</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse1:",
          "content": "{\n    \"success\": true,\n    \"tender_parcels\": [],\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/tenders_controller.rb",
    "groupTitle": "Tenders"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/tender_winners?tender_id=1",
    "title": "",
    "name": "tender_winners",
    "group": "Tenders",
    "description": "<p>Tender winner list</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse1:",
          "content": "{\n    \"tender_winners\": [],\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/tenders_controller.rb",
    "groupTitle": "Tenders"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/tenders",
    "title": "",
    "name": "tenders",
    "group": "Tenders",
    "description": "<p>With Authentication token and withou authentication token</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"tenders\": [],\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/tenders_controller.rb",
    "groupTitle": "Tenders"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/tenders?supplier=11",
    "title": "",
    "name": "tenders",
    "group": "Tenders",
    "description": "<p>tenders according to supplier</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"tenders\": [],\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/tenders_controller.rb",
    "groupTitle": "Tenders"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/tenders?location=surat",
    "title": "",
    "name": "tenders_location",
    "group": "Tenders",
    "description": "<p>tenders according to Location</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"tenders\": [],\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/tenders_controller.rb",
    "groupTitle": "Tenders"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/tenders?month=1",
    "title": "",
    "name": "tenders_month",
    "group": "Tenders",
    "description": "<p>tenders according to month</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"tenders\": [],\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/tenders_controller.rb",
    "groupTitle": "Tenders"
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
