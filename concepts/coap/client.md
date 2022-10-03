# CoAP Client

A CoAP client is a CoAP [endpoint](@coap/endpoint) that sends requests to a listening endpoint
and processes the listener's responses.

A notable difference between HTTP clients and CoAP clients is that in CoAP,
there is almost no difference between clients and servers.

This means that as soon as the server is aware of the client,
it can also send requests to the client.

This can be incredibly useful for baking in events (e.g. real-time messaging)
to a [RESTful](@rest) [API](@net/api) without introducing
any new [network protocols](@net/protocol).
