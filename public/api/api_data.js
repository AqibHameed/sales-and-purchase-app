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
    "type": "get",
    "url": "/api/v1/app_versions",
    "title": "",
    "name": "app_versions",
    "group": "Api",
    "description": "<p>buyer send or update proposal</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"versions\": []\n}",
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
    "url": "/api/v1/app_versions?version=1.2",
    "title": "",
    "name": "app_versions_version___1_2",
    "group": "Api",
    "description": "<p>search app verions with version</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"version\": {\n        \"version\": \"1.2\",\n        \"force_upgrade\": true,\n        \"recommend_upgrade\": true\n    }\n}",
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
    "url": "/api/v1/company_list",
    "title": "",
    "name": "company_list",
    "group": "Api",
    "description": "<p>Show list of companies</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"pagination\": {\n        \"total_pages\": 144,\n        \"prev_page\": null,\n        \"next_page\": null,\n        \"current_page\": 1\n    },\n    \"companies\": [\n        {\n            \"id\": \"1\",\n            \"name\": \"Dummy co. 1\",\n            \"city\": null,\n            \"country\": \"India\",\n            \"created_at\": \"2018-10-25T11:21:17.000Z\",\n            \"updated_at\": \"2018-10-25T11:21:17.000Z\",\n            \"purchases_completed\": 3590,\n            \"suppliers_connected\": 1,\n            \"status\": false,\n            \"customers\": []\n        },\n        {\n            \"id\": \"2\",\n            \"name\": \"Dummy co. 2\",\n            \"city\": null,\n            \"country\": \"India\",\n            \"created_at\": \"2018-10-25T11:21:17.000Z\",\n            \"updated_at\": \"2018-10-25T11:21:17.000Z\",\n            \"purchases_completed\": 0,\n            \"suppliers_connected\": 2,\n            \"status\": true,\n            \"customers\": [\n                {\n                    \"id\": 3,\n                    \"first_name\": \"abc\",\n                    \"last_name\": \"xyz\"\n                }\n            ]\n        }\n    ],\n    \"response_code\": 200\n}",
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
    "url": "/api/v1/customer_list",
    "title": "",
    "name": "customer_list",
    "group": "Api",
    "description": "<p>get list of customer</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"pagination\": {\n        \"total_pages\": 1,\n        \"prev_page\": null,\n        \"next_page\": null,\n        \"current_page\": 1\n    },\n    \"customers\": [\n        {\n            \"id\": 5,\n            \"first_name\": \"abc\",\n            \"last_name\": \"def\",\n            \"email\": \"wetu@getnada.com\",\n            \"company\": \"Dummy co. 3\",\n            \"chat_id\": \"-1\"\n        },\n        {\n            \"id\": 3,\n            \"first_name\": \"abc\",\n            \"last_name\": \"xyz\",\n            \"email\": \"xabi@nada.email\",\n            \"company\": \"Dummy co. 2\",\n            \"chat_id\": \"-1\"\n        }\n    ],\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/api_controller.rb",
    "groupTitle": "Api"
  },
  {
    "version": "1.0.0",
    "type": "put",
    "url": "/api/v1/update_chat_id",
    "title": "",
    "name": "dupdate_chat_id",
    "group": "Api",
    "description": "<p>update authorized chat id</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n\t\"chat_id\": \"43AESdca43\"\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"customer\": {\n        \"chat_id\": \"43AESdca43\",\n        \"email\": \"ranu.ongraph@gmail.com\",\n        \"first_name\": \"test\",\n        \"last_name\": \"test\"\n    },\n    \"response_code\": 200\n}",
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
          "title": "SuccessResponse:",
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
          "title": "SuccessResponse:",
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
    "url": "/api/v1/brokers/accept",
    "title": "",
    "name": "Accept_request",
    "group": "Brokers",
    "description": "<p>accept request seller to broker or broker to seller</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n\t\"request_id\": 3\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n  success: true,\n  message: 'Request accepted successfully.',\n  status: 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/brokers_controller.rb",
    "groupTitle": "Brokers"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/brokers/send_request",
    "title": "",
    "name": "Send_request",
    "group": "Brokers",
    "description": "<p>send request seller to broker, broker to seller</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n\t\"company\": \"broker1(Broker)\"\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"message\": \"Request sent successfully\"\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/brokers_controller.rb",
    "groupTitle": "Brokers"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/brokers/assigned_parcels",
    "title": "",
    "name": "assigned_parcels",
    "group": "Brokers",
    "description": "<p>assign parcels to the broker</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"parcels\": []\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/brokers_controller.rb",
    "groupTitle": "Brokers"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/brokers/company_record_on_the_basis_of_roles",
    "title": "",
    "name": "company_record_on_the_basis_of_roles",
    "group": "Brokers",
    "description": "<p>get company record on the basis of roles</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n  \"success\": true,\n  \"pagination\": {\n      \"total_pages\": 1,\n      \"prev_page\": null,\n      \"next_page\": null,\n      \"current_page\": 1\n  },\n  \"company_record_on_the_basis_of_roles\": [\n      {\n          \"id\": 2,\n          \"name\": \"Buyer B\",\n          \"status\": \"SendRequest\"\n      },\n      {\n          \"id\": 3,\n          \"name\": \"Buyer C\",\n          \"status\": \"SendRequest\"\n      },\n      {\n          \"id\": 5,\n          \"name\": \"Seller B\",\n          \"status\": \"SendRequest\"\n      },\n      {\n          \"id\": 6,\n          \"name\": \"Seller C\",\n          \"status\": \"SendRequest\"\n      },\n      {\n          \"id\": 7,\n          \"name\": \"Dummy Buyer 1\",\n          \"status\": \"SendRequest\"\n      },\n      {\n          \"id\": 8,\n          \"name\": \"Dummy Seller 1\",\n          \"status\": \"SendRequest\"\n      },\n      {\n          \"id\": 9,\n          \"name\": \"Dummy Seller 2\",\n          \"status\": \"SendRequest\"\n      },\n      {\n          \"id\": 10,\n          \"name\": \"Dummy Buyer 2\",\n          \"status\": \"SendRequest\"\n      }\n  ]\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/brokers_controller.rb",
    "groupTitle": "Brokers"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/brokers/dashboard",
    "title": "",
    "name": "dashboard",
    "group": "Brokers",
    "description": "<p>get the list of assign parcel to broker</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n  \"success\": true,\n  \"parcels\": [\n      {\n          \"description\": \"Dummy Parcel for Demo\",\n          \"no_of_parcels\": 1,\n          \"no_of_demands\": 6\n      },\n      {\n          \"description\": \"Dummy Parcel for Demo\",\n          \"no_of_parcels\": 1,\n          \"no_of_demands\": 6\n      },\n      {\n          \"description\": \"Basket +14.8 ct-buffer\",\n          \"no_of_parcels\": 1,\n          \"no_of_demands\": 1\n      },\n      {\n          \"description\": \"+9 SAWABLES LIGHT\",\n          \"no_of_parcels\": 0,\n          \"no_of_demands\": 5\n      }\n  ]\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/brokers_controller.rb",
    "groupTitle": "Brokers"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/brokers/demanding_companies?id=1",
    "title": "",
    "name": "demanding_companies",
    "group": "Brokers",
    "description": "<p>buyers who are demanding that description of parcel</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n    \"id\": \"1\"\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n  \"success\": true,\n  \"companies\": [\n      {\n          \"id\": 7,\n          \"name\": \"Dummy Buyer 1\",\n          \"mobile_no\": \"+11111234455\"\n      },\n      {\n          \"id\": 7,\n          \"name\": \"Dummy Buyer 1\",\n          \"mobile_no\": \"+11111234455\"\n      },\n      {\n          \"id\": 9,\n          \"name\": \"Dummy Seller 2\",\n          \"mobile_no\": \"+11111231122\"\n      },\n      {\n          \"id\": 9,\n          \"name\": \"Dummy Seller 2\",\n          \"mobile_no\": \"+11111231122\"\n      },\n      {\n          \"id\": 10,\n          \"name\": \"Dummy Buyer 2\",\n          \"mobile_no\": \"+11111233344\"\n      },\n      {\n          \"id\": 10,\n          \"name\": \"Dummy Buyer 2\",\n          \"mobile_no\": \"+11111233344\"\n      }\n  ]\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/brokers_controller.rb",
    "groupTitle": "Brokers"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/brokers/reject",
    "title": "",
    "name": "reject_request",
    "group": "Brokers",
    "description": "<p>reject request seller to broker or broker to seller</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n\t\"request_id\": 3\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n  success: true,\n  message: 'Request rejected successfully.',\n  status: 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/brokers_controller.rb",
    "groupTitle": "Brokers"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/brokers/remove",
    "title": "",
    "name": "remove_request",
    "group": "Brokers",
    "description": "<p>reomve  seller or broker</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n\t\"request_id\": 3\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n  success: true,\n  message: 'You have removed successfully.',\n  status: 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/brokers_controller.rb",
    "groupTitle": "Brokers"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/brokers/show_myclients",
    "title": "",
    "name": "show_all_connected_sellers_buyers_or_brokers",
    "group": "Brokers",
    "description": "<p>show connected sellers/buyers or broker</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"pagination\": {\n        \"total_pages\": 1,\n        \"prev_page\": null,\n        \"next_page\": null,\n        \"current_page\": 1\n    },\n    \"response_code\": 200,\n    \"myclients\": [\n        {\n            \"request_id\": 9,\n            \"broker_name\": \"broker 1\",\n            \"seller_buyer_name\": \"broker1(Broker)\"\n        }\n    ]\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/brokers_controller.rb",
    "groupTitle": "Brokers"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/brokers/show_requests",
    "title": "",
    "name": "show_requests",
    "group": "Brokers",
    "description": "<p>show requests incoming from sellers/buyers or broker</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"pagination\": {\n        \"total_pages\": 1,\n        \"prev_page\": null,\n        \"next_page\": null,\n        \"current_page\": 1\n    },\n    \"response_code\": 200,\n    \"requests\": [\n        {\n            \"request_id\": 8,\n            \"broker_name\": \"broker 1\",\n            \"seller_buyer_name\": \"broker1(Broker)\"\n        }\n    ]\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/brokers_controller.rb",
    "groupTitle": "Brokers"
  },
  {
    "version": "1.0.0",
    "type": "delete",
    "url": "/api/v1/companies_groups/3589",
    "title": "",
    "name": "Destroy",
    "group": "CompaniesGroups",
    "description": "<p>Delete group with group id = 3589</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/companies_groups_controller.rb",
    "groupTitle": "CompaniesGroups"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/companies_groups",
    "title": "",
    "name": "create",
    "group": "CompaniesGroups",
    "description": "<p>create companies group</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n\t\"company_id\": [1],\n\t\"group_name\": \"testing group\",\n\t\"group_overdue_limit\": 2300,\n\t\"group_market_limit\": 5000\n\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"message\": \"Group created successfully\",\n    \"data\": {\n        \"id\": \"3589\",\n        \"group_name\": \"testing group\",\n        \"companies\": [\n            {\n                \"id\": \"1\",\n                \"name\": \"Dummy co. 1\",\n                \"total_limit\": 0,\n                \"used_limit\": 200,\n                \"available_limit\": 0,\n                \"overdue_limit\": \"30 days\",\n                \"supplier_connected\": \"1\"\n            }\n        ]\n    },\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/companies_groups_controller.rb",
    "groupTitle": "CompaniesGroups"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/companies_groups",
    "title": "",
    "name": "index",
    "group": "CompaniesGroups",
    "description": "<p>get all groups</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"groups\": [\n        {\n            \"id\": \"3582\",\n            \"group_name\": \"Dummy Group\",\n            \"group_market_limit\": 200,\n            \"group_overdue_limit\": 300,\n            \"companies\": [\n                {\n                    \"id\": \"1\",\n                    \"name\": \"Dummy co. 1\",\n                    \"total_limit\": 0,\n                    \"used_limit\": 200,\n                    \"available_limit\": 0,\n                    \"overdue_limit\": \"30 days\",\n                    \"supplier_connected\": \"1\"\n                },\n                {\n                    \"id\": \"2\",\n                    \"name\": \"Dummy co. 2\",\n                    \"total_limit\": 0,\n                    \"used_limit\": 0,\n                    \"available_limit\": 0,\n                    \"overdue_limit\": \"30 days\",\n                    \"supplier_connected\": \"2\"\n                }\n            ]\n        },\n        {\n            \"id\": \"3589\",\n            \"group_name\": \"testing group\",\n            \"group_market_limit\": null,\n            \"group_overdue_limit\": 200,\n            \"companies\": [\n                {\n                    \"id\": \"1\",\n                    \"name\": \"Dummy co. 1\",\n                    \"total_limit\": 0,\n                    \"used_limit\": 200,\n                    \"available_limit\": 0,\n                    \"overdue_limit\": \"30 days\",\n                    \"supplier_connected\": \"1\"\n                }\n            ]\n        }\n    ]\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/companies_groups_controller.rb",
    "groupTitle": "CompaniesGroups"
  },
  {
    "version": "1.0.0",
    "type": "put",
    "url": "/api/v1/companies_groups/3589",
    "title": "",
    "name": "update",
    "group": "CompaniesGroups",
    "description": "<p>update companies group</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n\t\"company_id\": [1],\n\t\"group_name\": \"testing group\",\n\t\"group_overdue_limit\": 2300,\n\t\"group_market_limit\": 5000\n\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"message\": \"Group updated successfully\",\n    \"data\": {\n        \"id\": \"3589\",\n        \"group_name\": \"testing group\",\n        \"companies\": [\n            {\n                \"id\": \"1\",\n                \"name\": \"Dummy co. 1\",\n                \"total_limit\": 0,\n                \"used_limit\": 200,\n                \"available_limit\": 0,\n                \"overdue_limit\": \"30 days\",\n                \"supplier_connected\": \"1\"\n            }\n        ]\n    },\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/companies_groups_controller.rb",
    "groupTitle": "CompaniesGroups"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/blocked_customers",
    "title": "",
    "name": "blocked_customers",
    "group": "Companies",
    "description": "<p>get blocked Customer</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"blocked_customers\": [\n        {\n            \"id\": \"1\",\n            \"company\": \"Dummy co. 1\",\n            \"city\": null,\n            \"country\": \"India\",\n            \"created_at\": \"2018-10-25T11:21:17.000Z\",\n            \"updated_at\": \"2018-10-25T11:21:17.000Z\"\n        }\n    ],\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/companies_controller.rb",
    "groupTitle": "Companies"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/companies_review",
    "title": "",
    "name": "companies_review",
    "group": "Companies",
    "description": "<p>review the companies</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n company_id: 1,\n know: true,\n trade: false,\n recommend: true,\n experience: true\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n  \"review\": {\n      \"id\": 1,\n      \"know\": true,\n      \"trade\": false,\n      \"recommend\": true,\n      \"experience\": true\n  },\n  \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/companies_controller.rb",
    "groupTitle": "Companies"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/count_companies_review",
    "title": "",
    "name": "count_companies_review",
    "group": "Companies",
    "description": "<p>count the companies review questions</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n  \"success\": true,\n  \"companies_rated_count\": {\n      \"know\": {\n          \"yes\": 1,\n          \"no\": 0\n      },\n      \"trade\": {\n          \"yes\": 0,\n          \"no\": 1\n      },\n      \"recommend\": {\n          \"yes\": 0,\n          \"no\": 0\n      },\n      \"experience\": {\n          \"yes\": 0,\n          \"no\": 0\n      },\n      \"total_number_of_comapnies_rated\": 1\n  }\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/companies_controller.rb",
    "groupTitle": "Companies"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/history",
    "title": "",
    "name": "history",
    "group": "Companies",
    "description": "<p>get history of all transactions</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"pagination\": {\n        \"total_pages\": 1,\n        \"prev_page\": null,\n        \"next_page\": null,\n        \"current_page\": 1\n    },\n    \"transactions\": [\n        {\n            \"id\": 10744,\n            \"buyer_id\": 1,\n            \"seller_id\": 3585,\n            \"trading_parcel_id\": 10745,\n            \"due_date\": \"2018-11-23T18:30:00+00:00\",\n            \"avg_price\": \"10.0\",\n            \"credit\": 30,\n            \"paid\": false,\n            \"created_at\": \"2018-10-25T12:20:51.000Z\",\n            \"invoice_date\": \"2018-10-25T12:20:51+00:00\",\n            \"updated_at\": \"2018-10-25T12:20:51.000Z\",\n            \"buyer_confirmed\": true,\n            \"reject_reason\": null,\n            \"reject_date\": null,\n            \"transaction_type\": \"manual\",\n            \"amount_to_be_paid\": \"100.0\",\n            \"transaction_uid\": \"9ac4579796e01a860fad5c84\",\n            \"diamond_type\": \"Rough\",\n            \"total_amount\": \"100.0\",\n            \"invoice_no\": null,\n            \"ready_for_buyer\": null,\n            \"description\": \"OutSide Goods Dummy Parcel for Demo\",\n            \"activity\": \"Sold\",\n            \"counter_party\": \"Dummy co. 1\",\n            \"payment_status\": \"Overdue\",\n            \"no_of_stones\": null,\n            \"carats\": \"10.00\",\n            \"cost\": \"10.0\",\n            \"box_value\": \"12\",\n            \"sight\": \"07/18\",\n            \"comment\": \"This is a Demo Parcel\",\n            \"confirm_status\": true,\n            \"paid_date\": null,\n            \"seller_days_limit\": 30,\n            \"buyer_days_limit\": 54\n        }\n    ]\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/companies_controller.rb",
    "groupTitle": "Companies"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/invite",
    "title": "",
    "name": "invite",
    "group": "Companies",
    "description": "<p>invite company</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n \"company\": \"test_test\",\n \"email\": \"hello@123.com\",\n \"country\": \"India\"\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"message\": \" Company is invited successfully\",\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/companies_controller.rb",
    "groupTitle": "Companies"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/companies/list_permission_companies",
    "title": "",
    "name": "list_permission_companies",
    "group": "Companies",
    "description": "<p>list of companies who has given permission to view his financial data.</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n  \"success\": true,\n  \"companies\": [\n      {\n          \"id\": 8,\n          \"name\": \"Dummy Seller 1\",\n          \"city\": \"\",\n          \"county\": \"India\",\n          \"created_at\": \"2018-12-06T09:12:54.000Z\",\n          \"updated_at\": \"2018-12-06T09:12:54.000Z\",\n          \"is_anonymous\": false,\n          \"add_polished\": false,\n          \"is_broker\": false,\n          \"email\": null,\n          \"deleted_at\": null\n      }\n  ],\n \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/companies_controller.rb",
    "groupTitle": "Companies"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/secure_center?receiver_id=2",
    "title": "",
    "name": "live_monitoring",
    "group": "Companies",
    "description": "<p>get secure center data for buyer</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse1:",
          "content": "{\n    \"success\": true,\n    \"details\": {\n        \"id\": 255,\n        \"buyer_id\": 1,\n        \"seller_id\": 4,\n        \"outstandings\": 47000,\n        \"overdue_amount\": 47000,\n        \"supplier_connected\": 1,\n        \"permitted\": false,\n        \"balance_credit_limit\": 57000,\n        \"collection_ratio_days\": [\n            {\n                \"zer_percent\": 0,\n                \"less_fiften\": 1,\n                \"less_thirty\": 0,\n                \"less_fourty_five\": 0,\n                \"greater_fourty_five\": 0\n            }\n        ],\n        \"paid_date\": \"2018-12-11\"\n    }\n}",
          "type": "json"
        },
        {
          "title": "SuccessResponse2:",
          "content": "{\n    \"success\": true,\n    \"details\": {\n        \"id\": 263,\n        \"buyer_id\": 1,\n        \"seller_id\": 4,\n        \"supplier_connected\": 10,\n        \"overdue_amount\": 0,\n        \"invoices_overdue\": 11,\n        \"outstandings\": 0,\n        \"last_bought_on\": \"2019-01-22\",\n        \"buyer_percentage\": 0,\n        \"system_percentage\": 30.61,\n        \"balance_credit_limit\": 7000,\n        \"permitted\": true,\n        \"number_of_seller_offer_credit\": 2,\n        \"collection_ratio_days\": {\n            \"zero_percent\": 0,\n            \"less_fifteen\": 1,\n            \"less_thirty\": 0,\n            \"less_fourty_five\": 0,\n            \"greater_fourty_five\": 0\n        },\n        \"buyer_score\": 0,\n        \"paid_date\": null\n    }\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/companies_controller.rb",
    "groupTitle": "Companies"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/companies/remove_permission",
    "title": "",
    "name": "remove_permission",
    "group": "Companies",
    "description": "<p>remove the permission of the company.</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n  \"company_id\": 1,\n  \"live_monitor\": false,\n  \"secure_center\": false,\n  \"buyer_score\": false,\n  \"seller_score\": false,\n  \"customer_info\": false\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n  \"success\": true,\n  \"message\": \"Request is removed successfully.\",\n  \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/companies_controller.rb",
    "groupTitle": "Companies"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/reset_limits",
    "title": "",
    "name": "reset_limits",
    "group": "Companies",
    "description": "<p>reset limit against compnay</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n\"company_id\": 1\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"message\": \"Limits are reset successfully\",\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/companies_controller.rb",
    "groupTitle": "Companies"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/seller_companies",
    "title": "",
    "name": "seller_companies",
    "group": "Companies",
    "description": "<p>shows the list of companies</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse1:",
          "content": "{\n   \"errors\": \"permission Access denied\",\n   \"response_code\": 201\n}",
          "type": "json"
        },
        {
          "title": "SuccessResponse:",
          "content": " {\n   \"success\": true,\n   \"pagination\": {\n       \"total_pages\": 1,\n       \"prev_page\": null,\n       \"next_page\": null,\n       \"current_page\": 1\n   },\n   \"companies\": [\n       {\n           \"id\": 7,\n           \"name\": \"Dummy Buyer 1\",\n           \"transaction_count\": 5,\n           \"amount_due\": \"10975.29\",\n           \"overdue_status\": true\n       },\n       {\n           \"id\": 10,\n           \"name\": \"Dummy Buyer 2\",\n           \"transaction_count\": 1,\n           \"amount_due\": \"3300.0\",\n           \"overdue_status\": true\n       }\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/companies_controller.rb",
    "groupTitle": "Companies"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/companies/show_review",
    "title": "",
    "name": "show_review",
    "group": "Companies",
    "description": "<p>Show reviews  of the company.</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n    \"company_id\": 4,\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "  {\n\"review\": {\n    \"id\": 7,\n    \"know\": true,\n    \"trade\": false,\n    \"recommend\": true,\n    \"experience\": false\n},\n\"response_code\": 200",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/companies_controller.rb",
    "groupTitle": "Companies"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/access_tiles?tab=inbox",
    "title": "",
    "name": "access_tiles",
    "group": "Customers",
    "description": "<p>permission the tiles and sorting the record on the basis of count</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n\t\"tab\": \"smart_search\",\n  \"tab\": \"sell\",\n  \"tab\": \"inbox\",\n  \"tab\": \"history\",\n  \"tab\": \"live_monitor\",\n  \"tab\": \"public_channels\",\n  \"tab\": \"feedback\",\n  \"tab\": \"share_app\",\n  \"tab\": \"invite\",\n  \"tab\": \"current_tenders\",\n  \"tab\": \"upcoming_tenders\",\n  \"tab\": \"protection\",\n  \"tab\": \"record_sale\",\n  \"tab\": \"past_tenders\"\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n {\n   \"success\": true,\n   \"messages\": [\n       {\n           \"Inbox\": true,\n           \"count\": 5\n       },\n       {\n           \"History\": true,\n           \"count\": 0\n       },\n       {\n           \"Smart Search\": true,\n           \"count\": 0\n       }\n   ]\n }\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/customers_controller.rb",
    "groupTitle": "Customers"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/customers/buyer_scores",
    "title": "",
    "name": "buyer_scores",
    "group": "Customers",
    "description": "<p>get Buyer scores</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example1:",
          "content": "{\n  receiver_id: \"\"\n}",
          "type": "json"
        },
        {
          "title": "Request-Example2:",
          "content": "{\n  receiver_id: \"1\"\n}",
          "type": "json"
        },
        {
          "title": "Request-Example3:",
          "content": "{\n  receiver_id: \"2\"\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse1:",
          "content": "{\n  \"errors\": \"company id not exist\",\n  \"response_code\": 201\n}",
          "type": "json"
        },
        {
          "title": "SuccessResponse2:",
          "content": "{\n   \"errors\": \"permission Access denied\",\n   \"response_code\": 201\n}",
          "type": "json"
        },
        {
          "title": "SuccessResponse3:",
          "content": " {\n    \"success\": true,\n    \"scores\": [\n        {\n            \"name\": \"Late Payment\",\n            \"user_score\": 0,\n            \"market_average\": 12.11,\n            \"user_score_vs_market_score\": 0\n        },\n        {\n            \"name\": \"Current Risk Score\",\n            \"user_score\": 0,\n            \"market_average\": 144.77,\n            \"user_score_vs_market_score\": 0\n        },\n        {\n            \"name\": \"Network Diversity\",\n            \"user_score\": 0,\n            \"market_average\": 90.4,\n            \"user_score_vs_market_score\": 0\n        },\n        {\n            \"name\": \"Buyer Network Score\",\n            \"user_score\": 0,\n            \"market_average\": 1.15,\n            \"user_score_vs_market_score\": 0\n        },\n        {\n            \"name\": \"Due Date Score\",\n            \"user_score\": 0,\n            \"market_average\": 35.06,\n            \"user_score_vs_market_score\": 0\n        },\n        {\n            \"name\": \"Credit Used Score\",\n            \"user_score\": 0,\n            \"market_average\": 0.64,\n            \"user_score_vs_market_score\": 0\n        },\n        {\n            \"name\": \"Number Of Suppliers Giving You Credit\",\n            \"user_score\": 0,\n            \"market_average\": 3,\n            \"user_score_vs_market_score\": 0\n        },\n        {\n            \"buyer_score\": 0\n        }\n    ],\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/customers_controller.rb",
    "groupTitle": "Customers",
    "sampleRequest": [
      {
        "url": "https://safetrade.ai/api/v1/customers/buyer_scores"
      }
    ]
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/customers/feedback_rating",
    "title": "",
    "name": "feedback_rating",
    "group": "Customers",
    "description": "<p>to get customer feedback info, You can send &quot;proposal_id&quot;: &quot;1&quot; or &quot;demand_id&quot;: &quot;1&quot; or &quot;partial_payment_id&quot;: &quot;1&quot; or &quot;credit_limit_id&quot;: &quot;1&quot; or trading_parcel_id&quot;: &quot;1&quot;,</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "\n{\n\t\"trading_parcel_id\": \"1\",\n  \"star\": \"4\"\n    \"comment\": \"This seller is Good\"\n\n\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:{",
          "content": " {\n  \"feedback\": {\n          \"id\": 1,\n          \"comments\": null,\n          \"feedback_rating\": 3,\n          \"trading_parcel_id\": 1\n      },\n   \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/customers_controller.rb",
    "groupTitle": "Customers"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/customers/info",
    "title": "",
    "name": "info",
    "group": "Customers",
    "description": "<p>to get customer purchasings, transaction and sales info</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example1:",
          "content": "{\n  receiver_id: \"\"\n}",
          "type": "json"
        },
        {
          "title": "Request-Example2:",
          "content": "{\n  receiver_id: \"1\"\n}",
          "type": "json"
        },
        {
          "title": "Request-Example3:",
          "content": "{\n  receiver_id: \"2\"\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse1:",
          "content": "{\n  \"errors\": \"company id not exist\",\n  \"response_code\": 201\n}",
          "type": "json"
        },
        {
          "title": "SuccessResponse2:",
          "content": "{\n   \"errors\": \"permission Access denied\",\n   \"response_code\": 201\n}",
          "type": "json"
        },
        {
          "title": "SuccessResponse3:",
          "content": "{\n  \"success\": true,\n  \"sales\": {\n      \"credit_given_to\": 3,\n      \"total_given_credit\": \"22695.00\",\n      \"total_used_credit\": \"16154.33\",\n      \"total_available_credit\": \"$6,540.67\",\n      \"sales\": [\n          {\n              \"term\": \"cash\",\n              \"percent\": \"0(0%)\",\n              \"pending_transaction\": \"$0.00(0%)\",\n              \"overdue_transaction\": \"$0.00(0%)\",\n              \"complete_transaction\": \"$0.00(0%)\"\n          },\n          {\n              \"term\": \"1<=30\",\n              \"percent\": \"11(68%)\",\n              \"pending_transaction\": \"$0.00(0%)\",\n              \"overdue_transaction\": \"$13,200.00(89%)\",\n              \"complete_transaction\": \"$18,849.26(75%)\"\n          },\n          {\n              \"term\": \"61<=90\",\n              \"percent\": \"1(6%)\",\n              \"pending_transaction\": \"$0.00(0%)\",\n              \"overdue_transaction\": \"$0.00(0%)\",\n              \"complete_transaction\": \"$4,500.00(18%)\"\n          },\n          {\n              \"term\": \"91\",\n              \"percent\": \"2(12%)\",\n              \"pending_transaction\": \"$26.25(100%)\",\n              \"overdue_transaction\": \"$0.00(0%)\",\n              \"complete_transaction\": \"$1,549.04(6%)\"\n          },\n          {\n              \"term\": \"total\",\n              \"percent\": \"16\",\n              \"pending_transaction\": \"$26.25\",\n              \"overdue_transaction\": \"$14,749.04\",\n              \"complete_transaction\": \"$24,898.30\"\n          }\n      ]\n  },\n  \"purchases\": {\n      \"credit_recieved_count\": 1,\n      \"total_credit_received\": \"$3,300.00\",\n      \"purchases\": [\n          {\n              \"term\": \"cash\",\n              \"percent\": \"0(0%)\",\n              \"pending_transaction\": \"$0.00(0%)\",\n              \"overdue_transaction\": \"$0.00(0%)\",\n              \"complete_transaction\": \"$0.00(0%)\"\n          },\n          {\n              \"term\": \"1<=30\",\n              \"percent\": \"1(100%)\",\n              \"pending_transaction\": \"$0.00(0%)\",\n              \"overdue_transaction\": \"$0.00(0%)\",\n              \"complete_transaction\": \"$3,300.00(100%)\"\n          },\n          {\n              \"term\": \"31<=60\",\n              \"percent\": \"0(0%)\",\n              \"pending_transaction\": \"$0.00(0%)\",\n              \"overdue_transaction\": \"$0.00(0%)\",\n              \"complete_transaction\": \"$0.00(0%)\"\n          },\n          {\n              \"term\": \"61<=90\",\n              \"percent\": \"0(0%)\",\n              \"pending_transaction\": \"$0.00(0%)\",\n              \"overdue_transaction\": \"$0.00(0%)\",\n              \"complete_transaction\": \"$0.00(0%)\"\n          },\n          {\n              \"term\": \"61<=90\",\n              \"percent\": \"0(0%)\",\n              \"pending_transaction\": \"$0.00(0%)\",\n              \"overdue_transaction\": \"$0.00(0%)\",\n              \"complete_transaction\": \"$0.00(0%)\"\n          },\n          {\n              \"term\": \"total\",\n              \"percent\": \"1\",\n              \"pending_transaction\": \"$0.00\",\n              \"overdue_transaction\": \"$0.00\",\n              \"complete_transaction\": \"$3,300.00\"\n          }\n      ]\n  },\n  \"transactions\": {\n      \"total\": 15,\n      \"pending\": 1,\n      \"completed\": 9,\n      \"overdue\": 5\n  }\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/customers_controller.rb",
    "groupTitle": "Customers"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/customers/seller_scores",
    "title": "",
    "name": "seller_scores",
    "group": "Customers",
    "description": "<p>get seller scores</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example1:",
          "content": "{\n  receiver_id: \"\"\n}",
          "type": "json"
        },
        {
          "title": "Request-Example2:",
          "content": "{\n  receiver_id: \"1\"\n}",
          "type": "json"
        },
        {
          "title": "Request-Example3:",
          "content": "{\n  receiver_id: \"2\"\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse1:",
          "content": "{\n  \"errors\": \"company id not exist\",\n  \"response_code\": 201\n}",
          "type": "json"
        },
        {
          "title": "SuccessResponse2:",
          "content": "{\n   \"errors\": \"permission Access denied\",\n   \"response_code\": 201\n}",
          "type": "json"
        },
        {
          "title": "SuccessResponse3:",
          "content": " {\n    \"success\": true,\n    \"scores\": [\n        {\n            \"name\": \"Late Payment\",\n            \"user_score\": 62.25,\n            \"market_average\": 13.9,\n            \"user_score_vs_market_score\": 4.48\n        },\n        {\n            \"name\": \"Current Risk Score\",\n            \"user_score\": 75,\n            \"market_average\": 198.95,\n            \"user_score_vs_market_score\": 0.38\n        },\n        {\n            \"name\": \"Network Diversity\",\n            \"user_score\": 0,\n            \"market_average\": 477.13,\n            \"user_score_vs_market_score\": 0\n        },\n        {\n            \"name\": \"Seller Network Score\",\n            \"user_score\": 3.46,\n            \"market_average\": 1.41,\n            \"user_score_vs_market_score\": 2.45\n        },\n        {\n            \"name\": \"Due Date Score\",\n            \"user_score\": 43.31,\n            \"market_average\": 37.37,\n            \"user_score_vs_market_score\": 1.16\n        },\n        {\n            \"name\": \"Credit Used Score\",\n            \"user_score\": 1.78,\n            \"market_average\": 1.1,\n            \"user_score_vs_market_score\": 1.62\n        },\n        {\n            \"seller_score\": 2.02\n        }\n    ],\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/customers_controller.rb",
    "groupTitle": "Customers",
    "sampleRequest": [
      {
        "url": "https://safetrade.ai/api/v1/customers/seller_scores"
      }
    ]
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/demands?demand_supplier_id=4&description[]=PINKCOLOR&description[]=BLUECOLOR",
    "title": "",
    "name": "create",
    "group": "Demands",
    "description": "<p>Create demands</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "nothing only params in url",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"message\": \"Demand created successfully.\",\n    \"demands\": {\n        \"id\": 10820,\n        \"description\": \"BLUE COLOR\",\n        \"weight\": null,\n        \"price\": null,\n        \"company_id\": 3585,\n        \"diamond_type\": null,\n        \"created_at\": \"2018-12-18T12:10:58.000Z\",\n        \"updated_at\": \"2018-12-18T12:10:58.000Z\",\n        \"demand_supplier_id\": 4,\n        \"block\": false,\n        \"deleted\": false\n    }\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/demands_controller.rb",
    "groupTitle": "Demands"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/demands/demand_description",
    "title": "",
    "name": "demand_description",
    "group": "Demands",
    "description": "<p>show demand description</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"descriptions\": [\n        \"Z -7+5\",\n        \"Z -7\",\n        \"Z -5+3\",\n        \"Z 3 grs +7 (mele)\",\n        \"Z 3 grs (mele)\",\n        \"Z -3\",\n        \"Z +9 (mele)\",\n        \"Z +7 (mele)\",\n        \"Z +11 (mele)\",\n        \"Z / Longs 3grs / +7\",\n        \"Z / Longs 3 grs\",\n        \"Z / Longs -11+9\",\n        \"Z / Longs +7\",\n        \"Z / Longs +11\",\n        \"Z / Cliv -2 grs+3\",\n        \"Z / Cliv 11+9\",\n        \"Z / Cliv +7\",\n        \"Z / Cliv +5\",\n        \"Z / Cliv +3\",\n        \"Z / Cliv +11\"\n    ],\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/demands_controller.rb",
    "groupTitle": "Demands"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/demands/demand_suppliers",
    "title": "",
    "name": "demand_suppliers",
    "group": "Demands",
    "description": "<p>show demand sources</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"demand_suppliers\": [\n        {\n            \"id\": 1,\n            \"name\": \"Sight\"\n        },\n        {\n            \"id\": 2,\n            \"name\": \"RUSSIAN\"\n        },\n        {\n            \"id\": 3,\n            \"name\": \"OUTSIDE\"\n        },\n        {\n            \"id\": 4,\n            \"name\": \"SPECIAL\"\n        },\n        {\n            \"id\": 5,\n            \"name\": \"POLISHED\"\n        }\n    ],\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/demands_controller.rb",
    "groupTitle": "Demands"
  },
  {
    "version": "1.0.0",
    "type": "delete",
    "url": "/api/v1/demands/10820",
    "title": "",
    "name": "destroy",
    "group": "Demands",
    "description": "<p>Delete demand with demnad_id = 10820</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"message\": \"Demand destroy successfully\"\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/demands_controller.rb",
    "groupTitle": "Demands"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/demands",
    "title": "",
    "name": "index",
    "group": "Demands",
    "description": "<p>show list of demands</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"response_code\": 200,\n    \"demands\": [\n        {\n            \"id\": 1,\n            \"name\": \"Sight\",\n            \"descriptions\": [\n                {\n                    \"id\": 10744,\n                    \"description\": \"Dummy Parcel for Demo\",\n                    \"parcels\": 0\n                }\n            ]\n        },\n        {\n            \"id\": 2,\n            \"name\": \"RUSSIAN\",\n            \"descriptions\": [\n                {\n                    \"id\": 10745,\n                    \"description\": \"Dummy Parcel for Demo\",\n                    \"parcels\": 0\n                }\n            ]\n        },\n        {\n            \"id\": 3,\n            \"name\": \"OUTSIDE\",\n            \"descriptions\": [\n                {\n                    \"id\": 10746,\n                    \"description\": \"Dummy Parcel for Demo\",\n                    \"parcels\": 1\n                }\n            ]\n        },\n        {\n            \"id\": 4,\n            \"name\": \"POLISHED\",\n            \"descriptions\": []\n        }\n    ]\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/demands_controller.rb",
    "groupTitle": "Demands"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/demands/live_demands",
    "title": "",
    "name": "live_demands",
    "group": "Demands",
    "description": "<p>get live demands with authorization token</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"live_demands\": {\n        \"rough\": [\n            {\n                \"description\": \"PINK COLOR\",\n                \"no_of_demands\": 1,\n                \"date\": \"2018-12-18T12:10:58+00:00\"\n            }\n        ],\n        \"polished\": []\n    },\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/demands_controller.rb",
    "groupTitle": "Demands"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/demands/parcels_list",
    "title": "",
    "name": "parcels_list",
    "group": "Demands",
    "description": "<p>show parcel list</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"pagination\": {\n        \"total_pages\": 1,\n        \"prev_page\": null,\n        \"next_page\": null,\n        \"current_page\": 1\n    },\n    \"parcels\": [\n        {\n            \"proposal_send\": true,\n            \"proposal_id\": 18,\n            \"is_mine\": false,\n            \"is_overdue\": false,\n            \"id\": \"10754\",\n            \"description\": \"+100 CT\",\n            \"lot_no\": null,\n            \"no_of_stones\": 100,\n            \"carats\": 100,\n            \"credit_period\": 50,\n            \"avg_price\": 110,\n            \"company\": \"SafeTrade\",\n            \"cost\": 100,\n            \"discount_per_month\": null,\n            \"sight\": null,\n            \"source\": \"SPECIAL\",\n            \"uid\": \"527566f4\",\n            \"percent\": 10,\n            \"comment\": \"\",\n            \"total_value\": 11000,\n            \"size_info\": [],\n            \"proposal_status\": \"rejected\",\n            \"my_offer\": null,\n            \"demand_id\": 10753\n        },\n        {\n            \"proposal_send\": false,\n            \"proposal_id\": null,\n            \"is_mine\": false,\n            \"is_overdue\": false,\n            \"id\": \"10757\",\n            \"description\": \"PINK COLOR\",\n            \"lot_no\": null,\n            \"no_of_stones\": 10,\n            \"carats\": 100,\n            \"credit_period\": 100,\n            \"avg_price\": 110,\n            \"company\": \"SafeTrade\",\n            \"cost\": 100,\n            \"discount_per_month\": \"0\",\n            \"sight\": \"\",\n            \"source\": \"SPECIAL\",\n            \"uid\": \"1dee48ab\",\n            \"percent\": 10,\n            \"comment\": \"\",\n            \"total_value\": 11000,\n            \"size_info\": [],\n            \"proposal_status\": \"no\",\n            \"my_offer\": null,\n            \"demand_id\": 10819\n        }\n    ],\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/demands_controller.rb",
    "groupTitle": "Demands"
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
    "url": "/api/v1/limits/block",
    "title": "",
    "name": "block",
    "group": "Limits",
    "description": "<p>Block any company</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n\t\"company_id\": 1\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/limits_controller.rb",
    "groupTitle": "Limits"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/limits/credit_limit_list?company_id=1&page=1&count=3",
    "title": "",
    "name": "credit_limit_list",
    "group": "Limits",
    "description": "<p>show list of credit limit</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"limits\": {\n        \"id\": 1,\n        \"name\": \"Dummy co. 1\",\n        \"total_limit\": 0,\n        \"used_limit\": 200,\n        \"available_limit\": 0,\n        \"overdue_limit\": \"30 days\",\n        \"supplier_connected\": 3588,\n        \"reviewed\": false\n    },\n    \"response_code\": 200\n}",
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
    "url": "/api/v1/limits/unblock",
    "title": "",
    "name": "unblock",
    "group": "Limits",
    "description": "<p>unBlock any company</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n\t\"company_id\": 1\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true\n}",
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
    "url": "/api/v1/messages",
    "title": "",
    "name": "CREATE",
    "group": "Messages",
    "description": "<p>create message</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": " {\"message\":{\n\t\"subect\": \"Proposal send\",\n\t\"message\": \"this is contant\",\n\t\"message_type\": \"simple\",\n\t\"receiver_id\": \"3\"\n}\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"message\": \"Message Created Successfully\"\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/messages_controller.rb",
    "groupTitle": "Messages"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/messages",
    "title": "",
    "name": "index",
    "group": "Messages",
    "description": "<p>Get all messages of authorized user</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"pagination\": {\n        \"total_pages\": 1,\n        \"prev_page\": null,\n        \"next_page\": null,\n        \"current_page\": 1\n    },\n    \"messages\": [\n        {\n            \"id\": 2,\n            \"proposal_id\": 2,\n            \"sender\": \"SafeTrade\",\n            \"receiver\": \"OnGraph\",\n            \"message\": \" </br>For more Details about proposal, <a href=\\\"/proposals/2\\\">Click Here</a>\",\n            \"message_type\": \"Proposal\",\n            \"subject\": \"Seller sent a new proposal.\",\n            \"created_at\": \"2018-10-25T12:44:44.000Z\",\n            \"updated_at\": \"2018-10-25T12:44:44.000Z\",\n            \"date\": \"2018-10-25T12:44:44.000Z\",\n            \"description\": \"+100 CT\",\n            \"status\": \"accepted\",\n            \"calculation\": -9.09\n        },\n        {\n            \"request_id\": 9,\n            \"sender\": \"Seller A\",\n            \"message\": \"You have a new live monitoring request from seller\"\n        }\n    ],\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/messages_controller.rb",
    "groupTitle": "Messages"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/messages/2",
    "title": "",
    "name": "show",
    "group": "Messages",
    "description": "<p>show single message with message_id = 2</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"message\": {\n        \"id\": 2,\n        \"sender\": \"SafeTrade\",\n        \"receiver\": \"OnGraph\",\n        \"message\": \" </br>For more Details about proposal, <a href=\\\"/proposals/2\\\">Click Here</a>\",\n        \"message_type\": \"Proposal\",\n        \"subject\": \"Seller sent a new proposal.\",\n        \"created_at\": \"2018-10-25T12:44:44.000Z\",\n        \"updated_at\": \"2018-10-25T12:44:44.000Z\"\n    },\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/messages_controller.rb",
    "groupTitle": "Messages"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "api/v1/proposals/:id/accept_and_decline?perform=accept",
    "title": "",
    "name": "accept_and_decline__accept_case_",
    "group": "Proposals",
    "description": "<p>proposal accept</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"message\": \"Proposal is accepted.\",\n    \"response_code\": 201\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/proposals_controller.rb",
    "groupTitle": "Proposals"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "api/v1/proposals/:id/accept_and_decline?perform=reject",
    "title": "",
    "name": "accept_and_decline__reject_case_",
    "group": "Proposals",
    "description": "<p>proposal reject</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"message\": \"Proposal is rejected.\",\n    \"response_code\": 201\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/proposals_controller.rb",
    "groupTitle": "Proposals"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/proposals/3",
    "title": "",
    "name": "create",
    "group": "Proposals",
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
          "content": "{\n\"trading_parcel_id\" : \"3\",\n\"credit\" : \"2000\",\n\"price\" : \"4500\",\n\"total_value\" : \"4000\"\n}",
          "type": "json"
        },
        {
          "title": "Request-Example3:",
          "content": "{\n\"id\" : \"3\",\n\"credit\" : \"2000\",\n\"price\" : \"5000\",\n\"total_value\" : \"500000\"\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse1:",
          "content": "{\n    \"success\": false,\n    \"message\": \"Please contact seller to increase limits.\"\n}",
          "type": "json"
        },
        {
          "title": "SuccessResponse2:",
          "content": "{\n    \"success\": true,\n    \"message\": \"Proposal Submitted Successfully\"\n}",
          "type": "json"
        },
        {
          "title": "SuccessResponse3:",
          "content": "{\n    \"success\": true,\n    \"message\": \"Proposal Updated Successfully\"\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/proposals_controller.rb",
    "groupTitle": "Proposals"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/proposals/:id/negotiate",
    "title": "",
    "name": "negotiate",
    "group": "Proposals",
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
    "groupTitle": "Proposals"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/proposals/22",
    "title": "",
    "name": "show",
    "group": "Proposals",
    "description": "<p>show proposal with proposal_id = 22</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"proposal\": {\n        \"status\": null,\n        \"supplier_name\": \"SafeTrade\",\n        \"source\": \"SPECIAL\",\n        \"description\": \"PINK COLOR\",\n        \"sight\": \"\",\n        \"no_of_stones\": 1000,\n        \"carats\": \"1000.0\",\n        \"cost\": 1000,\n        \"list_percentage\": 10,\n        \"list_avg_price\": 1100,\n        \"list_total_price\": 1100000,\n        \"list_credit\": 1000,\n        \"list_discount\": 0,\n        \"list_comment\": \"\",\n        \"offered_percent\": 10,\n        \"offered_price\": 1100,\n        \"offered_credit\": 1000,\n        \"offered_total_value\": 1100000,\n        \"offered_comment\": null,\n        \"negotiated\": null\n    },\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/proposals_controller.rb",
    "groupTitle": "Proposals"
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
          "title": "Request-Example1:",
          "content": "{\n\t{\n   \"registration\": {\n      \"first_name\":\"umair\",\n      \"last_name\":\"raza\",\n      \"email\":\"umair@gmail.com\",\n      \"password\":\"password\",\n      \"confirmPassword\":\"password\",\n      \"company_id\":\"4\",\n      \"mobile_no\":\"12345688898\",\n      \"country_code\":\"86\",\n      \"role\": \"Buyer/Trader/Broker\",\n      \"company_individual\": \"Individual\"\n    }\n  }\n}",
          "type": "json"
        },
        {
          "title": "Request-Example1:",
          "content": "{\n\t{\n   \"registration\": {\n      \"first_name\":\"umair\",\n      \"last_name\":\"raza\",\n      \"email\":\"umair@gmail.com\",\n      \"password\":\"password\",\n      \"confirmPassword\":\"password\",\n      \"company_id\":\"4\",\n      \"mobile_no\":\"12345688898\",\n      \"country_code\":\"86\",\n      \"role\": \"Trader/Broker\",\n      \"company_individual\": \"Individual\"\n    }\n  }\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse1:",
          "content": "{\n    {\n      \"success\": true,\n      \"message\": \"A request has been to sent to your company admin for approval. You can access your account after approval\",\n      \"customer\": {\n          \"id\": 23,\n          \"email\": \"umair@gmail.com\",\n          \"created_at\": \"2018-12-24T13:15:52.000Z\",\n          \"updated_at\": \"2018-12-24T13:15:57.000Z\",\n          \"first_name\": \"umair\",\n          \"last_name\": \"raza\",\n          \"city\": null,\n          \"address\": null,\n          \"postal_code\": null,\n          \"phone\": null,\n          \"status\": null,\n          \"company\": \"Seller A\",\n          \"company_address\": null,\n          \"phone_2\": null,\n          \"mobile_no\": \"+86 12345688898\",\n          \"authentication_token\": \"_iw1Ns3W3Su3QpMrT88e\",\n          \"chat_id\": \"-1\",\n          \"token\": null\n     },\n     \"response_code\": 200\n   }\n}",
          "type": "json"
        },
        {
          "title": "SuccessResponse1:",
          "content": "{\n  {\n      \"errors\": [\n          \"Company already registered as Trader\"\n      ],\n      \"response_code\": 201\n  }\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/registrations_controller.rb",
    "groupTitle": "Registeration"
  },
  {
    "version": "1.0.0",
    "type": "get",
    "url": "/api/v1/get_customer",
    "title": "",
    "name": "customer_by_token",
    "group": "Session",
    "description": "<p>get customer from authorization token add in header</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"customer\": {\n        \"id\": 5,\n        \"email\": \"testing@gmail.com\",\n        \"designation\": \"Trader\",\n        \"created_at\": \"2018-10-30T07:26:20.000Z\",\n        \"updated_at\": \"2018-11-01T11:19:12.000Z\",\n        \"first_name\": \"abc\",\n        \"last_name\": \"def\",\n        \"city\": null,\n        \"address\": null,\n        \"postal_code\": null,\n        \"phone\": null,\n        \"status\": null,\n        \"company_id\": \"7\",\n        \"company\": \"Dummy co. 3\",\n        \"company_email\": null,\n        \"company_country\":  \"India\",\n        \"company_address\": null,\n        \"phone_2\": null,\n        \"mobile_no\": \"+971 551114466\",\n        \"authentication_token\": \"hGazWDBk_Pkh8wn2jA\",\n        \"chat_id\": \"-1\",\n        \"token\": null\n    },\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/sessions_controller.rb",
    "groupTitle": "Session"
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
          "content": "{\n    \"customer\": {\n        \"id\": 21,\n        \"email\": \"umair.raza101@gmail.com\",\n        \"designation\": \"Trader\",\n        \"created_at\": \"2018-12-07T15:00:19.000Z\",\n        \"updated_at\": \"2018-12-17T18:32:41.000Z\",\n        \"first_name\": \"Umair\",\n        \"last_name\": \"Raza\",\n        \"city\": null,\n        \"address\": null,\n        \"postal_code\": null,\n        \"phone\": null,\n        \"status\": null,\n        \"company_id\": \"7\",\n        \"company\": \"Dummy Seller 1\",\n        \"company_email\": null,\n        \"company_country\":  \"India\",\n        \"company_address\": null,\n        \"phone_2\": null,\n        \"mobile_no\": \"+1\",\n        \"authentication_token\": \"XwHsMFNtQAy6aFpttQek\",\n        \"chat_id\": \"-1\",\n        \"token\": null\n    },\n    \"response_code\": 200\n}",
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
          "title": "SuccessResponse:",
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
          "title": "SuccessResponse:",
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
          "title": "SuccessResponse:",
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
    "url": "/api/v1/old_tender_parcel?tender_id=3",
    "title": "",
    "name": "old_tender_parcel",
    "group": "Tenders",
    "description": "<p>old tender parcels</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
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
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"tender_parcels\": [\n        {\n            \"id\": 1270,\n            \"stone_type\": \"Parcel\",\n            \"no_of_stones\": 14,\n            \"size\": null,\n            \"weight\": 206.61,\n            \"purity\": null,\n            \"color\": null,\n            \"polished\": null,\n            \"deec_no\": 1,\n            \"lot_no\": 1,\n            \"description\": \"+10.8CT CLIVAGE\",\n            \"comments\": null,\n            \"valuation\": null,\n            \"parcel_rating\": null,\n            \"images\": [],\n            \"winners_data\": [],\n            \"highlight_parcel\": false\n        },\n        {\n            \"id\": 1271,\n            \"stone_type\": \"Parcel\",\n            \"no_of_stones\": 2,\n            \"size\": null,\n            \"weight\": 24.6,\n            \"purity\": null,\n            \"color\": null,\n            \"polished\": null,\n            \"deec_no\": 2,\n            \"lot_no\": 2,\n            \"description\": \"+10.8CT BROWN MIX\",\n            \"comments\": null,\n            \"valuation\": null,\n            \"parcel_rating\": null,\n            \"images\": [],\n            \"winners_data\": [],\n            \"highlight_parcel\": false\n        }\n    ],\n    \"response_code\": 200\n  }",
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
          "title": "SuccessResponse:",
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
    "url": "/api/v1/trading_parcels",
    "title": "",
    "name": "create",
    "group": "TradingParcels",
    "description": "<p>create parcel</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\"trading_parcel\":\n   {\n   \t   \"source\": \"SPECIAL\",\n\t   \"description\": \"5-10 Cts BLK CLIV WHITE\",\n\t   \"credit_period\": \"2000\",\n\t   \"no_of_stones\": \"10\",\n\t   \"total_value\": 5000.0,\n\t   \"percent\": \"10\",\n\t   \"cost\": 4500.0,\n\t   \"avg_price\": 5000.0,\n\t   \"carats\": 1,\n\t   \"comment\": \"\",\n\t   \"discout\": \"\",\n\t   \"sight\": \"\",\n\t   \"lot_no\":\"\",\n\t   \"parcel_size_infos_attributes\":[\n\t   \t  {\n\t   \t    \"size\": \"M\",\n\t   \t    \"percent\": 20,\n\t   \t    \"_destroy\": \"false\"\n\t   \t  },\n\t   \t  {\n\t   \t    \"size\": \"1\",\n\t   \t    \"percent\": 30,\n\t   \t    \"_destroy\": \"false\"\n\t   \t  }\n\t   ]\n   }\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"message\": \"Parcel created successfully\"\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/trading_parcels_controller.rb",
    "groupTitle": "TradingParcels"
  },
  {
    "version": "1.0.0",
    "type": "delete",
    "url": "/api/v1/trading_parcels/1",
    "title": "",
    "name": "destroy",
    "group": "TradingParcels",
    "description": "<p>delete customer's parcels parcel_id = 1</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"message\": \"This parcel is deleted successfully.\"\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/trading_parcels_controller.rb",
    "groupTitle": "TradingParcels"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/trading_parcels/direct_sell",
    "title": "",
    "name": "direct_sell",
    "group": "TradingParcels",
    "description": "<p>direct sell (3,4 request where role is trader and have to send activity param with buy or sell) and direct buyer (2 request where role is buyer)</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example1:",
          "content": "{\n            \"trading_parcel\": {\n                \"description\": \"Z -7+5T\",\n                \"activity\": \"sell\",\n                \"my_transaction_attributes\": {\n                    \"company_id\": \"11\",\n                    \"paid\": false\n                },\n                \"no_of_stones\": 10,\n                \"carats\": 1,\n                \"credit_period\": 20,\n                \"price\": 2200,\n                \"company\": \"SafeTrade\",\n                \"cost\": 2000,\n                \"sight\": \"12/2018\",\n                \"source\": \"DTC\",\n                \"percent\": 10,\n                \"comment\": \"\",\n                \"total_value\": 2200\n            },\n            \"check_transactions\": true\n}",
          "type": "json"
        },
        {
          "title": "Request-Example2:",
          "content": " {\n  \"trading_parcel\":\n                  {\n                  \"description\":\"+11 SAWABLES LIGHT\",\n                  \"my_transaction_attributes\":\n                                             {\n                                               \"customer_id\":\"2\",\n                                               \"paid\":false,\n                                               \"created_at\":\"23/11/2018\"\n                                             },\n                   \"no_of_stones\":10,\n                   \"carats\":1.0,\n                   \"credit_period\":20,\n                   \"price\":6600.0,\n                   \"company\":\"SafeTrade\",\n                   \"cost\":6000.0,\n                   \"sight\":\"11/2018\",\n                   \"source\":\"RUSSIAN\",\n                   \"percent\":10.0,\n                   \"comment\":\"\",\n                   \"total_value\":7000.0\n\n                  },\n                  \"available_credit_limit\": true\n\n}",
          "type": "json"
        },
        {
          "title": "Request-Example3:",
          "content": "{\n  \"trading_parcel\":\n                  {\n                  \"description\":\"+11 SAWABLES LIGHT\",\n                  \"activity\": \"buy\",\n                  \"my_transaction_attributes\":\n                                             {\n                                               \"company_id\":\"2\",\n                                               \"paid\":false,\n                                               \"created_at\":\"23/11/2018\"\n                                             },\n                   \"no_of_stones\":10,\n                   \"carats\":1.0,\n                   \"credit_period\":20,\n                   \"price\":6600.0,\n                   \"company\":\"SafeTrade\",\n                   \"cost\":6000.0,\n                   \"sight\":\"11/2018\",\n                   \"source\":\"RUSSIAN\",\n                   \"percent\":10.0,\n                   \"comment\":\"\",\n                   \"total_value\":7000.0\n\n                  },\n                  \"available_credit_limit\": true\n\n}",
          "type": "json"
        },
        {
          "title": "Request-Example4:",
          "content": "{\n  \"trading_parcel\":\n                  {\n                  \"description\":\"+11 SAWABLES LIGHT\",\n                  \"activity\": \"sell\",\n                  \"my_transaction_attributes\":\n                                             {\n                                               \"company_id\":\"2\",\n                                               \"paid\":false,\n                                               \"created_at\":\"23/11/2018\"\n                                             },\n                   \"no_of_stones\":10,\n                   \"carats\":1.0,\n                   \"credit_period\":20,\n                   \"price\":6600.0,\n                   \"company\":\"SafeTrade\",\n                   \"cost\":6000.0,\n                   \"sight\":\"11/2018\",\n                   \"source\":\"RUSSIAN\",\n                   \"percent\":10.0,\n                   \"comment\":\"\",\n                   \"total_value\":7000.0\n\n                  },\n                  \"available_credit_limit\": true\n\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse1:",
          "content": "{\n    \"success\": false,\n    \"details\": {\n        \"id\": 257,\n        \"invoices_overdue\": 0,\n        \"paid_date\": null,\n        \"buyer_id\": 11,\n        \"seller_id\": 4,\n        \"last_bought_on\": null,\n        \"supplier_connected\": 0,\n        \"credit_limit\": true,\n        \"overdue_limit\": false,\n        \"overdue_amount\": 0,\n        \"outstandings\": 0,\n        \"buyer_percentage\": 0,\n        \"system_percentage\": 31.46\n    }\n}",
          "type": "json"
        },
        {
          "title": "SuccessResponse2:",
          "content": "[\n {\n   \"success\": true,\n   \"notice\": \"Transaction added successfully\"\n }\n]",
          "type": "json"
        },
        {
          "title": "SuccessResponse3:",
          "content": "[\n {\n   \"success\": true,\n   \"notice\": \"Transaction added successfully\"\n }\n]",
          "type": "json"
        },
        {
          "title": "SuccessResponse4:",
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
    "url": "/api/v1/trading_parcels",
    "title": "",
    "name": "index",
    "group": "TradingParcels",
    "description": "<p>show list of trading parcel</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"pagination\": {\n        \"total_pages\": 1,\n        \"prev_page\": null,\n        \"next_page\": null,\n        \"current_page\": 1\n    },\n    \"parcels\": [\n        {\n            \"id\": \"10744\",\n            \"source\": \"OUTSIDE\",\n            \"description\": \"Dummy Parcel for Demo\",\n            \"total_value\": \"100.00\"\n        },\n        {\n            \"id\": \"10746\",\n            \"source\": \"POLISHED\",\n            \"description\": null,\n            \"total_value\": \"240.00\"\n        }\n    ],\n    \"response_code\": 200\n}",
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
    "url": "/api/v1/trading_parcels/3",
    "title": "",
    "name": "show",
    "group": "TradingParcels",
    "description": "<p>show trading parcel with parcel_id = 3</p>",
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"parcel\": {\n        \"id\": \"3\",\n        \"description\": null,\n        \"lot_no\": null,\n        \"no_of_stones\": 0,\n        \"carats\": 10,\n        \"credit_period\": 30,\n        \"avg_price\": 10,\n        \"company\": \"3D DIAMONDS Nv\",\n        \"cost\": 10,\n        \"discount_per_month\": \"0\",\n        \"sight\": null,\n        \"source\": \"POLISHED\",\n        \"uid\": \"f5f41260\",\n        \"percent\": 0,\n        \"comment\": \"This is Dummy Polished Parcel\",\n        \"total_value\": 240,\n        \"no_of_demands\": 0,\n        \"size_info\": [],\n        \"vital_sales_data\": {\n            \"demanded_clients\": []\n        }\n    },\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/trading_parcels_controller.rb",
    "groupTitle": "TradingParcels"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/transactions/make_payment",
    "title": "",
    "name": "make_payment",
    "group": "Transactions",
    "description": "<p>make payment of trading parcel, if current login user, role is buyer and confirm parameter value is nil or false then this Api show the message do AGree or not</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example1:",
          "content": "{\n\t\"transaction_id\": 1,\n\t\"amount\": 200\n}",
          "type": "json"
        },
        {
          "title": "Request-Example2:",
          "content": "{\n\t\"transaction_id\": 1,\n\t\"amount\": 200,\n  \"confirm\": false\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse1:",
          "content": "{\n  success: true, message: \"Payment is made successfully.\",\n  response_code: 201\n}",
          "type": "json"
        },
        {
          "title": "SuccessResponse2:",
          "content": "{\n  success: true, message: \"Do you Agree? Yes or No.\",\n  response_code: 201\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/transactions_controller.rb",
    "groupTitle": "Transactions"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/transactions/seller_accept_or_reject",
    "title": "",
    "name": "seller_accept_or_reject",
    "group": "Transactions",
    "description": "<p>seller acept or reject buyer request if seller_confirm is true then transaction will be confirm and if seller_reject is true then transaction will be reject</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example1:",
          "content": "{\n  \"id\": 17,\n  \"seller_confirm\": \"true\"\n}",
          "type": "json"
        },
        {
          "title": "Request-Example2:",
          "content": "{\n  \"id\": 17,\n  \"seller_reject\": \"true\"\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse1:",
          "content": "{\n  \"success\": true,\n    \"message\": \"Transaction confirm successfully\"\n}",
          "type": "json"
        },
        {
          "title": "SuccessResponse2:",
          "content": "{\n  \"success\": true,\n  \"message\": \"Transaction rejected successfully\"\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/transactions_controller.rb",
    "groupTitle": "Transactions"
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/companies/accept_secuirty_data_request",
    "title": "",
    "name": "accept_secuirty_data_request",
    "group": "companies_controller",
    "description": "<p>accept request to show security data</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n\t\"request_id\": 9,\n  \"live_monitor\":true,\n  \"buyer_score\":true,\n  \"seller_score\":false,\n  \"customer_info\":true\n\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"message\": \"Request accepted successfully.\",\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/companies_controller.rb",
    "groupTitle": "companies_controller",
    "sampleRequest": [
      {
        "url": "https://safetrade.ai/api/v1/companies/accept_secuirty_data_request"
      }
    ]
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/companies/reject_secuirty_data_request",
    "title": "",
    "name": "reject_secuirty_data_request",
    "group": "companies_controller",
    "description": "<p>reject request to show security data</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n\t\"request_id\": 9\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"message\": \"Request rejected successfully.\",\n    \"response_code\": 200\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/companies_controller.rb",
    "groupTitle": "companies_controller",
    "sampleRequest": [
      {
        "url": "https://safetrade.ai/api/v1/companies/reject_secuirty_data_request"
      }
    ]
  },
  {
    "version": "1.0.0",
    "type": "post",
    "url": "/api/v1/companies/send_security_data_request",
    "title": "",
    "name": "send_security_data_request",
    "group": "companies_controller",
    "description": "<p>send request to show security data</p>",
    "parameter": {
      "examples": [
        {
          "title": "Request-Example:",
          "content": "{\n\t\"receiver_id\": 2\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "SuccessResponse:",
          "content": "{\n    \"success\": true,\n    \"message\": \"Request send successfully.\",\n    \"response_code\": 201\n}",
          "type": "json"
        }
      ]
    },
    "filename": "app/controllers/api/v1/companies_controller.rb",
    "groupTitle": "companies_controller",
    "sampleRequest": [
      {
        "url": "https://safetrade.ai/api/v1/companies/send_security_data_request"
      }
    ]
  }
] });
