<!-- {"alias": "rest"} -->
# REST

**RE**presentational **S**tate **T**ransfer is a way of modeling an [API](@API) as
[atomic](@atomic) [actions](@HTTP-Method) that can be performed on [resources](@Resource)

For example, if you wanted to design a RESTful Pizza ordering API:
 - Get an Order by ID `GET http://{baseUrl}/orders/{id}`
 - Create an Order `POST http://{baseUrl}/orders`
 - Delete an Order `DELETE http://{baseUrl}/orders`
 - Update (or insert) an Order `PUT http://{baseUrl}/orders`
