<!-- {"ident": "coap"} -->
# CoAP

The **Co**nstrained **A**pplication **P**rotocol is a [RESTful](@rest)
[networking protocol](@net/protocol) that is an alternative to [HTTP](@http).

Compared to [HTTP](@http), CoAP is simpler, provides [lower latency](@net/latency),
and better power consumption.

In general, CoAP [clients](@coap/client) send [requests](@coap/request) to [servers](@coap/server),
who [respond](@coap/response) with a [status code](@coap/code) and a [payload](@coap/payload).

Both requests and responses contain [Options](@coap/options) (the analog to [HTTP Headers](@http/headers))
which encode things like "what [format](@coap/option/content-format) is the [payload](@coap/payload)?"
"what [version](@coap/option/etag) of this [resource](@rest/resource) does the client currently have?"

CoAP implements subscriptions with the [Observe](@coap/observe) feature, allowing
[clients](@coap/client) to be notified when a [server's](@coap/server) [resource](@rest/resource) changes.
