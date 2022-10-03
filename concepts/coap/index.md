<!-- {"ident": "coap"} -->
# CoAP

## TLDR
The **Co**nstrained **A**pplication **P**rotocol is a
[networking protocol](@net/protocol) that allows for writing rich [RESTful](@rest)
interfaces, and is an alternative to [HTTP](@http).

Compared to [HTTP](@http), CoAP is simpler, faster, [lower latency](@net/latency),
consumes less power, and less network bandwidth.

Some great usecases for CoAP include [IoT](@coap/usecase/iot),
[APIs with non-browser consumers](@coap/usecase/service),
and [Web APIs (with an HTTP proxy)](@coap/usecase/web).

## Transitioning to CoAP from HTTP
Because CoAP was modeled closely after HTTP, the transition tends to be very smooth.

All of the important [RESTful](@rest) features of HTTP have subtly changed,
so are named slightly differently:

### Headers
Request / Response [**Headers**](@http/header) become
Request / Response [**Options**](@coap/message/option) in CoAP.

Like headers, Options contain a key and a value
(e.g. `Content-Type: application/json` has an analog of `Content-Format: application/json`).

Unlike HTTP, however, the string name of the Option is not stored in the message.
Instead, the Option keys in CoAP messages are stored [as integers](@coap/option-code).

### Body
Request / Response **body** becomes Request / Response **payload**.

There are no semantic differences, both are a sequence of bytes that the
receiver of a message needs to parse according to `Content-Type` / `Content-Format`.

### Status Code
CoAP, like [HTTP](@http/status), has [status codes](@coap/message/status).

The mapping of some common status codes can be found on the
[CoAP status code](@coap/message/status) concept page.
