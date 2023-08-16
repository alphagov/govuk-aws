acl purge_ip_whitelist {
  "18.202.183.143";   # AWS NAT GW1 Staging
  "18.203.90.80";     # AWS NAT GW2 Staging
  "18.203.108.248";   # AWS NAT GW3 Staging
  "34.246.209.74";    # AWS NAT GW1 Production
  "34.253.57.8";      # AWS NAT GW2 Production
  "18.202.136.43";    # AWS NAT GW3 Production
  "54.246.115.159";   # EKS Staging NAT gateways
  "54.220.171.242";
  "54.228.115.164";
  "63.33.241.191";    # EKS Production NAT gateways
  "52.208.193.230";
  "54.220.6.200";
}

sub vcl_recv {
#FASTLY recv

  # Allow FASTLYPURGE from IPs defined in the ACL only, else return a HTTP 403
  if (req.request == "FASTLYPURGE" && !(client.ip ~ purge_ip_whitelist)) {
    error 403 "Forbidden";
  }

  # Redirect to security.txt for "/.well-known/security.txt" or "/security.txt"
  if (req.url.path ~ "(?i)^(?:/\.well[-_]known)?/security\.txt$") {
    error 805 "security.txt";
  }

  # Remove any Google Analytics campaign params
  set req.url = querystring.globfilter(req.url, "utm_*");

  # Sort query params (improve cache hit rate)
  set req.url = querystring.sort(req.url);

  if (req.url.path == "/") {
    # get rid of all query parameters
    set req.url = querystring.remove(req.url);
  }

  if (req.method != "HEAD" && req.method != "GET" && req.method != "FASTLYPURGE") {
    return(pass);
  }

  return(lookup);
}

sub vcl_fetch {
#FASTLY fetch

  if ((beresp.status == 500 || beresp.status == 503) && req.restarts < 1 && (req.method == "GET" || req.method == "HEAD")) {
    restart;
  }

  if (req.restarts > 0) {
    set beresp.http.Fastly-Restarts = req.restarts;
  }

  if (beresp.http.Set-Cookie) {
    set req.http.Fastly-Cachetype = "SETCOOKIE";
    return(pass);
  }

  if (beresp.http.Cache-Control ~ "private") {
    set req.http.Fastly-Cachetype = "PRIVATE";
    return(pass);
  }

  if (beresp.status == 500 || beresp.status == 503) {
    set req.http.Fastly-Cachetype = "ERROR";
    set beresp.ttl = 1s;
    set beresp.grace = 5s;
    return(deliver);
  }

  if (beresp.http.Expires || beresp.http.Surrogate-Control ~ "max-age" || beresp.http.Cache-Control ~ "(s-maxage|max-age)") {
    # keep the ttl here
  } else {
    # apply the default ttl
    set beresp.ttl = 3600s;
  }

  return(deliver);
}

sub vcl_hit {
#FASTLY hit

  if (!obj.cacheable) {
    return(pass);
  }
  return(deliver);
}

sub vcl_miss {
#FASTLY miss
  return(fetch);
}

sub vcl_deliver {
#FASTLY deliver
  return(deliver);
}

sub vcl_error {
#FASTLY error

  # 302 redirect to vdp.cabinetoffice.gov.uk called from vcl_recv.
  if (obj.status == 805) {
    set obj.status = 302;
    set obj.http.Location = "https://vdp.cabinetoffice.gov.uk/.well-known/security.txt";
    set obj.response = "Moved";
    synthetic {""};
    return (deliver);
  }
}

sub vcl_pass {
#FASTLY pass
}

sub vcl_log {
#FASTLY log
}
