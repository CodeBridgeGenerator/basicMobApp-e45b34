const assert = require("assert");
const app = require("../../src/app");

let usersRefData = [
  {
    name: "Standard User",
    email: "standard@example.com",
    password: "password",
  },
];

describe("products service", async () => {
  let thisService;
  let productCreated;
  let usersServiceResults;
  let users;

  

  beforeEach(async () => {
    thisService = await app.service("products");

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
    assert.ok(thisService, "Registered the service (products)");
  });

  describe("#create", () => {
    const options = {"name":"new value"};

    beforeEach(async () => {
      productCreated = await thisService.Model.create({...options, ...users});
    });

    it("should create a new product", () => {
      assert.strictEqual(productCreated.name, options.name);
    });
  });

  describe("#get", () => {
    it("should retrieve a product by ID", async () => {
      const retrieved = await thisService.Model.findById(productCreated._id);
      assert.strictEqual(retrieved._id.toString(), productCreated._id.toString());
    });
  });

  describe("#update", () => {
    const options = {"name":"updated value"};

    it("should update an existing product ", async () => {
      const productUpdated = await thisService.Model.findByIdAndUpdate(
        productCreated._id, 
        options, 
        { new: true } // Ensure it returns the updated doc
      );
      assert.strictEqual(productUpdated.name, options.name);
    });
  });

  describe("#delete", async () => {
    it("should delete a product", async () => {

      ;

      const productDeleted = await thisService.Model.findByIdAndDelete(productCreated._id);
      assert.strictEqual(productDeleted._id.toString(), productCreated._id.toString());
    });
  });
});