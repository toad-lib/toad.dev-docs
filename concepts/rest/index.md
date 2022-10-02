<!-- {"ident": "rest"} -->
# REST

**RE**presentational **S**tate **T**ransfer is a common way of modeling [APIs](@net/api) over the internet.

## TLDR
RESTful APIs model "things" (e.g. User, Pizza, Clothes) as [resources](@rest/resource) that you can perform
[atomic](@atomic) [actions](@http/method) on.

## Constraints
REST defines four constraints that differentiate REST from other API architecture styles:
 - Each request must uniquely identify a resource being acted on
 - A resource obtained from the server must be sufficient to modify that resource's state
 - Each message includes enough information to describe how to process the message
 - Hypermedia as the engine of application state (HATEOAS) - Having accessed an initial URI for the REST application a REST client should then be able to use server-provided links dynamically to discover all the available resources it needs.

## In Practice
In practice, the constraints of a REST interface (as a Web API) are usually fulfilled by the combination of:
 - [HTTP verbs](@http/method) (allows the client to have to know very little about that API in order to interact richly with it)
 - [HTTP headers](@http/header) (allows the client and server to attach metadata to resources, e.g. "who am I?" and "what format is the data in?")
 - [HTTP status codes](@http/status) (allows the client and server to attach metadata to resources, e.g. "who am I?" and "what format is the data in?")
 - URL of the request (allows the request to uniquely identify the resource, and resources to link to one another)

For example, if you wanted to design a RESTful Pizza ordering API:

```javascript
// Fetch all of my orders
// GET http://{baseUrl}/order/user/me
[
  {
    "id": 1,
    "pizzas": "http://{baseUrl}/pizza/1",
    "status": "delivered",
    "user": "http://{baseUrl}/user/25"
  },
  {
    "id": 2,
    "status": "not_placed",
    "pizzas": [
      { "href": "http://{baseUrl}/pizza/2" },
      { "href": "http://{baseUrl}/pizza/3" }
    ],
    "user": "http://{baseUrl}/user/25"
  }
]

// what is pizza 2?
// GET http://{baseUrl}/pizza/2
{
  "id": 2,
  "crust": {"href": "http://{baseUrl}/pizza/crust/deep_dish"},
  "sauce": {"href": "http://{baseUrl}/pizza/sauce/marinara"},
  "toppings": [
    {
      "amount": 2,
      "side": "both",
      "href": "http://{baseUrl}/topping/pepperoni"
    },
    {
      "amount": 1,
      "side": "left",
      "href": "http://{baseUrl}/topping/bell_pepper"
    }
  ],
  "drizzle": null
}

// Hmm... I actually don't want this pizza
// DELETE http://{baseUrl}/pizza/2
```
