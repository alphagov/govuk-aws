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
      "name": "search_api",
      "password": "${publishing_amazonmq_passwords["search_api"]}",
      "tags": ""
    }
  ],
  "vhosts": [
    {
      "name": "publishing"
    }
  ],
  "permissions": [
    {
      "user": "email_alert_service",
      "vhost": "publishing",
      "configure": "^(amq\\.gen.*|email_alert_service|email_unpublishing|subscriber_list_details_update_minor|subscriber_list_details_update_major)$",
      "write": "^(amq\\.gen.*|email_alert_service|email_unpublishing|subscriber_list_details_update_minor|subscriber_list_details_update_major)$",
      "read": "^(amq\\.gen.*|email_alert_service|email_unpublishing|subscriber_list_details_update_minor|subscriber_list_details_update_major|published_documents)$"
    },
    {
      "user": "content_data_api",
      "vhost": "publishing",
      "configure": "^$",
      "write": "^$",
      "read": "^content_data_api|content_data_api_govuk_importer|content_data_api_dead_letter_queue$"
    },
    {
      "user": "search_api",
      "vhost": "publishing",
      "configure": "^(amq\\.gen.*|search_api_to_be_indexed|search_api_govuk_index)$",
      "write": "^(amq\\.gen.*|search_api_to_be_indexed|search_api_govuk_index)$",
      "read": "^(amq\\.gen.*|search_api_to_be_indexed|search_api_govuk_index|search_api_bulk_reindex|published_documents)$"
    },
    {
      "user": "monitoring",
      "vhost": "publishing",
      "configure": "''",
      "write": "''",
      "read": ".*"
    },
    {
      "user": "publishing_api",
      "vhost": "publishing",
      "configure": "^amq\\.gen.*$",
      "write": "^(amq\\.gen.*|published_documents)$",
      "read": "^(amq\\.gen.*|published_documents)$"
    },
    {
      "user": "root",
      "vhost": "publishing",
      "configure": ".*",
      "write": ".*",
      "read": ".*"
    },
    {
      "user": "cache_clearing_service",
      "vhost": "publishing",
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
      "vhost": "publishing",
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
      "vhost": "publishing",
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
      "vhost": "publishing",
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
      "vhost": "publishing",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "email_alert_service",
      "vhost": "publishing",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "content_data_api_dead_letter_queue",
      "vhost": "publishing",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "subscriber_list_details_update_major",
      "vhost": "publishing",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "search_api_to_be_indexed",
      "vhost": "publishing",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "content_data_api_govuk_importer",
      "vhost": "publishing",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "subscriber_list_details_update_minor",
      "vhost": "publishing",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "search_api_bulk_reindex",
      "vhost": "publishing",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "content_data_api",
      "vhost": "publishing",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "cache_clearing_service-high",
      "vhost": "publishing",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "search_api_govuk_index",
      "vhost": "publishing",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "email_unpublishing",
      "vhost": "publishing",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    },
    {
      "name": "cache_clearing_service-medium",
      "vhost": "publishing",
      "durable": true,
      "auto_delete": false,
      "arguments": {}
    }
  ],
  "exchanges": [
    {
      "name": "published_documents",
      "vhost": "publishing",
      "type": "topic",
      "durable": true,
      "auto_delete": false,
      "internal": false,
      "arguments": {}
    },
    {
      "name": "content_data_api_dlx",
      "vhost": "publishing",
      "type": "topic",
      "durable": true,
      "auto_delete": false,
      "internal": false,
      "arguments": {}
    }
  ],
  "bindings": [
    {
      "source": "content_data_api_dlx",
      "vhost": "publishing",
      "destination": "content_data_api_dead_letter_queue",
      "destination_type": "queue",
      "routing_key": "#",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "publishing",
      "destination": "search_api_govuk_index",
      "destination_type": "queue",
      "routing_key": "*.*",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "publishing",
      "destination": "content_data_api_govuk_importer",
      "destination_type": "queue",
      "routing_key": "*.bulk.data-warehouse",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "publishing",
      "destination": "search_api_bulk_reindex",
      "destination_type": "queue",
      "routing_key": "*.bulk.reindex",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "publishing",
      "destination": "cache_clearing_service-low",
      "destination_type": "queue",
      "routing_key": "*.links",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "publishing",
      "destination": "content_data_api",
      "destination_type": "queue",
      "routing_key": "*.links",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "publishing",
      "destination": "search_api_to_be_indexed",
      "destination_type": "queue",
      "routing_key": "*.links",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "publishing",
      "destination": "cache_clearing_service-high",
      "destination_type": "queue",
      "routing_key": "*.major",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "publishing",
      "destination": "content_data_api",
      "destination_type": "queue",
      "routing_key": "*.major",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "publishing",
      "destination": "email_alert_service",
      "destination_type": "queue",
      "routing_key": "*.major.#",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "publishing",
      "destination": "subscriber_list_details_update_major",
      "destination_type": "queue",
      "routing_key": "*.major.#",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "publishing",
      "destination": "cache_clearing_service-medium",
      "destination_type": "queue",
      "routing_key": "*.minor",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "publishing",
      "destination": "content_data_api",
      "destination_type": "queue",
      "routing_key": "*.minor",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "publishing",
      "destination": "subscriber_list_details_update_minor",
      "destination_type": "queue",
      "routing_key": "*.minor.#",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "publishing",
      "destination": "cache_clearing_service-medium",
      "destination_type": "queue",
      "routing_key": "*.republish",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "publishing",
      "destination": "content_data_api",
      "destination_type": "queue",
      "routing_key": "*.republish",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "publishing",
      "destination": "cache_clearing_service-high",
      "destination_type": "queue",
      "routing_key": "*.unpublish",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "publishing",
      "destination": "content_data_api",
      "destination_type": "queue",
      "routing_key": "*.unpublish",
      "arguments": {}
    },
    {
      "source": "published_documents",
      "vhost": "publishing",
      "destination": "email_unpublishing",
      "destination_type": "queue",
      "routing_key": "*.unpublish.#",
      "arguments": {}
    }
  ]
}
