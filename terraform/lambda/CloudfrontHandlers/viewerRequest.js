'use strict';

exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request;
  const params = new URLSearchParams(request.querystring);

  Array.from(params.keys())
    .filter(k => k.toLowerCase().startsWith("utm_"))
    .forEach(k => params.delete(k));

  params.sort();

  request.querystring = params.toString();

  callback(null, request);
};
