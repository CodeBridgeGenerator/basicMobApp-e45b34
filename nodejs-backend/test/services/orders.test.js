const assert = require("assert");
const app = require("../../src/app");

let usersRefData = [
  {
    name: "Standard User",
    email: "standard@example.com",
    password: "password",
  },
];

describe("orders service", async () => {
  let thisService;
  let orderCreated;
  let usersServiceResults;
  let users;

  const customersCreated = await app.service("customers").Model.create({"orderNumber":"new value","customer":"parentObjectId","name":"new value"});
const productsCreated = await app.service("products").Model.create({"orderNumber":"new value","customer":`${customersCreated._id}`,"name":"new value","items":"parentObjectId","product":"parentObjectId"});
const itemsCreated = await app.service("items").Model.create({"orderNumber":"new value","customer":`${customersCreated._id}`,"name":"new value","items":"parentObjectId","product":`${productsCreated._id}`,"qty":23,"price":23});

  beforeEach(async () => {
    thisService = await app.service("orders");

    // Create users here
    usersServiceResults = await app.service("users").Model.create(usersRefData);
    users = {
      createdBy: usersServiceResults[0]._id,
      updatedBy: usersServiceResults[0]._id,
    };
  });

  after(async () => {
    if (usersServiceResults) {
      await Promise.all(
        usersServiceResults.map((i) =>
          app.service("users").Model.findByIdAndDelete(i._id)
        )
      );
    }
  });

  it("registered the service", () => {
    assert.ok(thisService, "Registered the service (orders)");
  });

  describe("#create", () => {
    const options = {"orderNumber":"new value","customer":`${customersCreated._id}`,"name":"new value","items":`${itemsCreated._id}`,"product":`${productsCreated._id}`,"qty":23,"price":23};

    beforeEach(async () => {
      orderCreated = await thisService.Model.create({...options, ...users});
    });

    it("should create a new order", () => {
      assert.strictEqual(orderCreated.orderNumber, options.orderNumber);
assert.strictEqual(orderCreated.customer.toString(), options.customer.toString());
assert.strictEqual(orderCreated.items.toString(), options.items.toString());
    });
  });

  describe("#get", () => {
    it("should retrieve a order by ID", async () => {
      const retrieved = await thisService.Model.findById(orderCreated._id);
      assert.strictEqual(retrieved._id.toString(), orderCreated._id.toString());
    });
  });

  describe("#update", () => {
    const options = {"orderNumber":"updated value","customer":`${customersCreated._id}`,"items":`${itemsCreated._id}`};

    it("should update an existing order ", async () => {
      const orderUpdated = await thisService.Model.findByIdAndUpdate(
        orderCreated._id, 
        options, 
        { new: true } // Ensure it returns the updated doc
      );
      assert.strictEqual(orderUpdated.orderNumber, options.orderNumber);
assert.strictEqual(orderUpdated.customer.toString(), options.customer.toString());
assert.strictEqual(orderUpdated.items.toString(), options.items.toString());
    });
  });

  describe("#delete", async () => {
    it("should delete a order", async () => {

      await app.service("customers").Model.findByIdAndDelete(customersCreated._id);
await app.service("products").Model.findByIdAndDelete(productsCreated._id);
await app.service("items").Model.findByIdAndDelete(itemsCreated._id);;

      const orderDeleted = await thisService.Model.findByIdAndDelete(orderCreated._id);
      assert.strictEqual(orderDeleted._id.toString(), orderCreated._id.toString());
    });
  });
});