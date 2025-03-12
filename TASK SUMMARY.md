### **Task scope and expectations**

* Your task is to create a food delivery service application.
* The project should be composed of a REST/GraphQL API and a Web Application.
* You need to write an API for a simple application where users can order meals from restaurants.
* This API should be usable by different front ends (web apps, mobile apps).
* The user must be able to create an account and log in using the API.
* Each user can have only one account (the user is identified by an email).
* A restaurant should have a name and description of the type of food they serve.
* A meal should have a name, description, and price.
* Orders consist of a list of meals, date, total amount, and status.
* An order should be placed for a single restaurant only, but it can have multiple meals.
* There is no need to handle payment of any kind or even to simulate payment handling.
* Restaurant owners and customers can change the order status respecting below flow and permissions:
  * Placed: Once a customer places an order.
  * Canceled: If the customer or restaurant owner cancels the order.
  * Processing: Once the restaurant owner starts to make the meals.
  * In Route: Once the meal is finished and the restaurant owner marks it's on the way.
  * Delivered: Once the restaurant owner receives information that the meal was delivered by their staff.
  * Received: Once the customer receives the meal and marks it as received.
* Status can not be changed by a different user than is stated above.
* Auto refresh of order status without the user needing to click anything.
* Orders should have a history of the date and time of the status change.
* Customers should be able to browse their order history and view updated order status.
* Customers and restaurant owners should be able to see a list of the orders.
* Allow date filtering, sorting, and pagination when viewing orders or menus.
* For the web application, you are provided with a UI boilerplate. You can use it entirely, partially, or just for inspiration if you want to create your own UI from scratch.
