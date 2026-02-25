const assert = require("assert");
const app = require("../../src/app");

let usersRefData = [
  {
    name: "Standard User",
    email: "standard@example.com",
    password: "password",
  },
];

describe("items service", async () => {
  let thisService;
  let itemCreated;
  let usersServiceResults;
  let users;

  const productsCreated = await app.service("products").Model.create({"product":"parentObjectId","name":"new value"});

  beforeEach(async () => {
    thisService = await app.service("items");

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
    assert.ok(thisService, "Registered the service (items)");
  });

  describe("#create", () => {
    const options = {"product":`${productsCreated._id}`,"name":"new value","qty":23,"price":23};

    beforeEach(async () => {
      itemCreated = await thisService.Model.create({...options, ...users});
    });

    it("should create a new item", () => {
      assert.strictEqual(itemCreated.product.toString(), options.product.toString());
assert.strictEqual(itemCreated.qty, options.qty);
assert.strictEqual(itemCreated.price, options.price);
    });
  });

  describe("#get", () => {
    it("should retrieve a item by ID", async () => {
      const retrieved = await thisService.Model.findById(itemCreated._id);
      assert.strictEqual(retrieved._id.toString(), itemCreated._id.toString());
    });
  });

  describe("#update", () => {
    const options = {"product":`${productsCreated._id}`,"qty":100,"price":100};

    it("should update an existing item ", async () => {
      const itemUpdated = await thisService.Model.findByIdAndUpdate(
        itemCreated._id, 
        options, 
        { new: true } // Ensure it returns the updated doc
      );
      assert.strictEqual(itemUpdated.product.toString(), options.product.toString());
assert.strictEqual(itemUpdated.qty, options.qty);
assert.strictEqual(itemUpdated.price, options.price);
    });
  });

  describe("#delete", async () => {
    it("should delete a item", async () => {

      await app.service("products").Model.findByIdAndDelete(productsCreated._id);;

      const itemDeleted = await thisService.Model.findByIdAndDelete(itemCreated._id);
      assert.strictEqual(itemDeleted._id.toString(), itemCreated._id.toString());
    });
  });
});