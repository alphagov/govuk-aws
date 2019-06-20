# 37. ALB Health Checks

Date: 2019-06-24

## Status

Accepted

## Context

On our platform, application instances receive traffic routed from a load balancer. Typically, an application instance runs Nginx
with a server_name based Vhost per application. Each application Vhost proxies the requests to the local port
where the application listens.

Load balancers use a health check to determine which instances to send traffic to. Health checks depend on the type of load
balancer and protocol in use. Usually we are going to configure health checks using TCP+PORT (ELBs) or HTTP+PORT+Request_path+Response_code
(ALB). For more information on health checks, have a look at the following links:

https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-healthchecks.html
https://docs.aws.amazon.com/elasticloadbalancing/latest/application/target-group-health-checks.html

When we configure HTTP health checks, the load balancer sends a request without a Host header. In this case, Nginx processes that
request in the default Vhost. These requests have been configured in the default Vhost to serve an `200 OK` response code, which indicates to the
load balancer that the instance is healthy and ready to receive traffic. This presents a problem when we are starting or redeploying
applications in that instance, because the application port will be unavailable for a period of time, and Nginx will serve 5xx responses. The
load balancer still sees the health check responses as `200 OK`, so it continues sending traffic to that instance, even though the application
is not ready to receive traffic.

The current ALB health check is rudimentary and does only test for the basic Nginx configuration being in place, rather than testing whether
all apps are properly deployed.  If an instance is terminated, this causes its replacement to be added to the target group pool prematurely which
causes elevated 5xx rates.

## Decision

When an instance is running more than one application, we are going to route traffic to the instance with an ALB. Each application has a dedicated
target group, with a specific health check path, following the format `/_healthcheck_<app-name>`.

This health check path is configured in the default Vhost to proxy the request to the upstream application, and rewrites the request to match the
application health check path that is also used in Icinga checks. This is configured in Puppet, in `govuk::app::config`, as the `health_check_path`
parameter.

The ALB includes routing rules based on Host header, and redirects the traffic to the application target group when the Host header matches
the value `<<app-name>.*`

## Consequences

If an application health check is broken or hasn't been deployed properly, the load balancer will see that target as unhealthy and won't send traffic
to.

We are going to have more target groups in the platform, we need to monitor closely the number of healthy hosts detected per target group and make
sure we alert is we detect problems.
