# CoAP

The **Co**nstrained **A**pplication **P**rotocol is a [RESTful](@REST)
[networking protocol](@Network-Protocol) that is an alternative to [HTTP](@HTTP).

Compared to [HTTP](@HTTP), CoAP is simpler, provides [lower latency](@Network-Latency),
and better power consumption.

In general, CoAP [clients](@CoAP-Client) send [requests](@CoAP-Request) to [servers](@CoAP-Server),
who [respond](@CoAP-Response) with a [status code](@CoAP-Code) and a [payload](@CoAP-Payload).

Both requests and responses contain [Options](@CoAP-Options) (the analog to [HTTP Headers](@HTTP-Headers))
which encode things like "what [format](@CoAP-Content-Format-Option) is the [payload](@CoAP-Payload)?"
"what [version](@CoAP-ETag-Option) of this [resource](@Resource) does the client currently have?"

CoAP implements subscriptions with the [Observe](@CoAP-Observe) feature, allowing
[clients](@CoAP-Client) to be notified when a [server's](@CoAP-Server) [resource](@Resource) changes.
