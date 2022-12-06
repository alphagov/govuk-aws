{
  "rabbit_version": "3.6.15",
  "users": [
    {
      "name": "content_data_api",
      "password": "${publishing_amazonmq_passwords["content_data_api"]}",
      "tags": ""
    },
    {
      "name": "publishing_api",
      "password": "${publishing_amazonmq_passwords["publishing_api"]}",
      "tags": ""
    },
    {
      "name": "email_alert_service",
      "password": "${publishing_amazonmq_passwords["email_alert_service"]}",
      "tags": ""
    },
    {
      "name": "cache_clearing_service",
      "password": "${publishing_amazonmq_passwords["cache_clearing_service"]}",
      "tags": ""
    },
    {
      "name": "monitoring",
      "password": "${publishing_amazonmq_passwords["monitoring"]}",
      "tags": "monitoring"
    },
    {
      "name": "search-api",
      "password": "${publishing_amazonmq_passwords["search-api"]}",
      "tags": ""
    }
  ],
  "vhosts": [
    {
      "name": "/"
    }
  ],
  "permissions": [
    {
      "user": "email_alert_service",
      "vhost": "/",
      "configure": "^(amq\\.gen.*|email_alert_service|email_unpublishing|subscriber_list_details_update_minor|subscriber_list_details_update_major)$",
      "write": "^(amq\\.gen.*|email_alert_service|email_unpublishing|subscriber_list_details_update_minor|subscriber_list_details_update_major)$",
      "read": "^(amq\\.gen.*|email_alert_service|email_unpublishing|subscriber_list_details_update_minor|subscriber_list_details_update_major|published_documents)$"
    },
    {
      "user": "content_data_api",
      "vhost": "/",
      "configure": "^$",
      "write": "^$",
      "read": "^content_data_api|content_data_api_govuk_importer|content_data_api_dead_letter_queue$"
    },
    {
      "user": "search-api",
      "vhost": "/",
      "configure": "^(amq\\.gen.*|search_api_to_be_indexed|search_api_govuk_index)$",
      "write": "^(amq\\.gen.*|search_api_to_be_indexed|search_api_govuk_index)$",
      "read": "^(amq\\.gen.*|search_api_to_be_indexed|search_api_govuk_index|search_api_bulk_reindex|published_documents)$"
    },
    {
      "user": "monitoring",
      "vhost": "/",
      "configure": "''",
      "write": "''",
      "read": ".*"
    },
    {
      "user": "publishing_api",
      "vhost": "/",
      "configure": "^amq\\.gen.*$",
      "write": "^(amq\\.gen.*|published_documents)$",
      "read": "^(amq\\.gen.*|published_documents)$"
    },
    {
      "user": "root",
      "vhost": "/",
      "configure": ".*",
      "write": ".*",
      "read": ".*"
    },
    {
      "user": "cache_clearing_service",
      "vhost": "/",
      "configure": "^$",
      "write": "^$",
      "read": "^cache_clearing_service-\\w+$"
    }
  ],
  "parameters": [],
  "global_parameters": [
    {
      "name": "cluster_name",
      "value": "${publishing_amazonmq_broker_name}"
    }
  ],
  "policies": [
    {
      "vhost": "/",
      "name": "cache_clearing_service-low-ttl",
      "pattern": "cache_clearing_service-low.*",
      "apply-to": "queues",
      "definition": {
        "ha-mode": "all",
        "ha-sync-mode": "automatic",
        "message-ttl": 1800000
      },
      "priority": 0
    },
    {
      "vhost": "/",
      "name": "content_data_api-dlx",
      "pattern": "^content_data_api.*",
      "apply-to": "queues",
      "definition": {
        "dead-letter-exchange": "content_data_api_dlx",
        "ha-mode": "all",
        "ha-sync-mode": "automatic"
      },
      "priority": 0
    },
    {
      "vhost": "/",
      "name": "ha-all",
      "pattern": ".*",
      "apply-to": "all",
      "definition": {
        "ha-mode": "all",
        "ha-sync-mode": "automatic"
      },
      "priority": 0
    }
  ],
  "queues": [
    {
      "name": "cache_clearing_service-low",
      "vhost": "/",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "email_alert_service",
      "vhost": "/",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "content_data_api_dead_letter_queue",
      "vhost": "/",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "subscriber_list_details_update_major",
      "vhost": "/",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "search_api_to_be_indexed",
      "vhost": "/",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "content_data_api_govuk_importer",
      "vhost": "/",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "subscriber_list_details_update_minor",
      "vhost": "/",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "search_api_bulk_reindex",
      "vhost": "/",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "content_data_api",
      "vhost": "/",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "cache_clearing_service-high",
      "vhost": "/",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "search_api_govuk_index",
      "vhost": "/",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "email_unpublishing",
      "vhost": "/",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "cache_clearing_service-medium",
      "vhost": "/",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    }
  ],
  "exchanges": [
    {
      "name": "published_documents",
      "vhost": "/",
      "type": "topic",
      "durable": false,
      "auto_delete": false,
      "internal": false,
      "arguments": {}
    },
    {
      "name": "content_data_api_dlx",
      "vhost": "/",
      "type": "topic",
      "durable": false,
      "auto_delete": false,
      "internal": false,
      "arguments": {}
    }
  ],
  "bindings": [
    {
      "source": "content_data_api_dlx",
      "vhost": "/",
      "destination": "content_data_api_dead_letter_queue",
      "destination_type": "queue",
      "routing_key": "#",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "/",
      "destination": "search_api_govuk_index",
      "destination_type": "queue",
      "routing_key": "*.*",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "/",
      "destination": "content_data_api_govuk_importer",
      "destination_type": "queue",
      "routing_key": "*.bulk.data-warehouse",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "/",
      "destination": "search_api_bulk_reindex",
      "destination_type": "queue",
      "routing_key": "*.bulk.reindex",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "/",
      "destination": "cache_clearing_service-low",
      "destination_type": "queue",
      "routing_key": "*.links",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "/",
      "destination": "content_data_api",
      "destination_type": "queue",
      "routing_key": "*.links",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "/",
      "destination": "search_api_to_be_indexed",
      "destination_type": "queue",
      "routing_key": "*.links",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "/",
      "destination": "cache_clearing_service-high",
      "destination_type": "queue",
      "routing_key": "*.major",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "/",
      "destination": "content_data_api",
      "destination_type": "queue",
      "routing_key": "*.major",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "/",
      "destination": "email_alert_service",
      "destination_type": "queue",
      "routing_key": "*.major.#",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "/",
      "destination": "subscriber_list_details_update_major",
      "destination_type": "queue",
      "routing_key": "*.major.#",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "/",
      "destination": "cache_clearing_service-medium",
      "destination_type": "queue",
      "routing_key": "*.minor",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "/",
      "destination": "content_data_api",
      "destination_type": "queue",
      "routing_key": "*.minor",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "/",
      "destination": "subscriber_list_details_update_minor",
      "destination_type": "queue",
      "routing_key": "*.minor.#",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "/",
      "destination": "cache_clearing_service-medium",
      "destination_type": "queue",
      "routing_key": "*.republish",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "/",
      "destination": "content_data_api",
      "destination_type": "queue",
      "routing_key": "*.republish",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "/",
      "destination": "cache_clearing_service-high",
      "destination_type": "queue",
      "routing_key": "*.unpublish",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "/",
      "destination": "content_data_api",
      "destination_type": "queue",
      "routing_key": "*.unpublish",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "/",
      "destination": "email_unpublishing",
      "destination_type": "queue",
      "routing_key": "*.unpublish.#",
      "arguments": {}
    }
  ]
}