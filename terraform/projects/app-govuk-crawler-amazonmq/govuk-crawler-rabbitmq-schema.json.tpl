{
    "rabbit_version": "3.6.15",
    "users": [
        {
            "name": "govuk_crawler_worker",
            "password_hash": "${govuk_crawler_amazonmq_passwords["govuk_crawler_worker"]}",
            "hashing_algorithm": "rabbit_password_hashing_sha256",
            "tags": ""
        },
        {
            "name": "monitoring",
            "password_hash": "${govuk_crawler_amazonmq_passwords["monitoring"]}",
            "hashing_algorithm": "rabbit_password_hashing_sha256",
            "tags": "monitoring"
        },
        {
            "name": "root",
            "password_hash": "${govuk_crawler_amazonmq_passwords["root"]}",
            "hashing_algorithm": "rabbit_password_hashing_sha256",
            "tags": "administrator"
        }
    ],
    "vhosts": [
        {
            "name": "/"
        }
    ],
    "permissions": [
        {
            "user": "monitoring",
            "vhost": "/",
            "configure": "''",
            "write": "''",
            "read": ".*"
        },
        {
            "user": "govuk_crawler_worker",
            "vhost": "/",
            "configure": "^(govuk_crawler.*)$",
            "write": "^(govuk_crawler.*)$",
            "read": "^(govuk_crawler.*)$"
        },
        {
            "user": "root",
            "vhost": "/",
            "configure": ".*",
            "write": ".*",
            "read": ".*"
        }
    ],
    "parameters": [],
    "global_parameters": [
        {
            "name": "cluster_name",
            "value": "rabbit@ip-10-1-6-15.eu-west-1.compute.internal"
        }
    ],
    "policies": [
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
            "name": "govuk_crawler_queue",
            "vhost": "/",
            "durable": true,
            "auto_delete": false,
            "arguments": {}
        }
    ],
    "exchanges": [
        {
            "name": "govuk_crawler_exchange",
            "vhost": "/",
            "type": "topic",
            "durable": true,
            "auto_delete": false,
            "internal": false,
            "arguments": {}
        }
    ],
    "bindings": [
        {
            "source": "govuk_crawler_exchange",
            "vhost": "/",
            "destination": "govuk_crawler_queue",
            "destination_type": "queue",
            "routing_key": "#",
            "arguments": {}
        }
    ]
}