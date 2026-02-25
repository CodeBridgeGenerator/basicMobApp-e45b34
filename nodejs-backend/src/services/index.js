const products = require("./products/products.service.js");
const orders = require("./orders/orders.service.js");
const customers = require("./customers/customers.service.js");
const items = require("./items/items.service.js");
// ~cb-add-require-service-name~

// eslint-disable-next-line no-unused-vars
module.exports = function (app) {
  app.configure(products);
  app.configure(orders);
  app.configure(customers);
  app.configure(items);
    // ~cb-add-configure-service-name~
};
