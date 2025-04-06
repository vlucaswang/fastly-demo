sub vcl_recv {

#FASTLY recv

  if (req.url.path == "/anything/here") {
    add req.http.X-CustomHeader = "incoming_client_request";
  }

  if (req.url.path == "/anything/not/found") {
    error 600;
  }

  return(lookup);
}


sub vcl_error {
#FASTLY error
  if (obj.status == 600) {
    set obj.status = 404;
    set obj.http.Content-Type = "text/html";
    synthetic {"<h1>Why are you looking for thing cannot be found? ^^</h1>"};
    return(deliver);
  }
}
