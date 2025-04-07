sub vcl_recv {
#FASTLY recv
  if (req.url.path == "/anything/here") {
    add req.http.X-CustomHeader = "incoming_client_request";
  }

  if (req.url.path == "/anything/not/found") {
    error 600;
  }

  if (req.protocol != "https") {
    error 602 "Force SSL";
  }

  if (client.geo.country_code ~ "(RU)") {
    set req.http.X-Country-Code = re.group.1;
    log req.http.X-Country-Code;
    error 403 "Restricted Content";
  }

  return(lookup);
}


sub vcl_fetch {
#FASTLY fetch
  if (req.url.path == "/image/jpeg") {
    #Preventing caching at the edge and in browsers
    set beresp.http.Cache-Control = "private, no-store"; # Don't cache in the browser
    set beresp.ttl = 3600s; # Cache in Fastly
    set beresp.ttl -= std.atoi(beresp.http.Age);
  }

  return(deliver);
}


sub vcl_error {
#FASTLY error
  if (obj.status == 600) {
    set obj.status = 404;
    set obj.http.Content-Type = "text/html";
    synthetic {"<h1>Why are you looking for things cannot be found? ^^</h1>"};
    return(deliver);
  }
  if (obj.status == 602 && obj.response == "Force SSL") {
    set obj.status = 301;
    set obj.response = "Moved Permanently";
    set obj.http.Location = "https://" req.http.host req.url;
    synthetic {""};
    return(deliver);
  }
}
