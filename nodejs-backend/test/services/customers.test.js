const assert = require("assert");
const app = require("../../src/app");

let usersRefData = [
  {
    name: "Standard User",
    email: "standard@example.com",
    password: "password",
  },
];

describe("customers service", async () => {
  let thisService;
  let customerCreated;
  let usersServiceResults;
  let users;

  

  beforeEach(async () => {
    thisService = await app.service("customers");

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
    assert.ok(thisService, "Registered the service (customers)");
  });

  describe("#create", () => {
    const options = {"name":"new value"};

    beforeEach(async () => {
      customerCreated = await thisService.Model.create({...options, ...users});
    });

    it("should create a new customer", () => {
      assert.strictEqual(customerCreated.name, options.name);
    });
  });

  describe("#get", () => {
    it("should retrieve a customer by ID", async () => {
      const retrieved = await thisService.Model.findById(customerCreated._id);
      assert.strictEqual(retrieved._id.toString(), customerCreated._id.toString());
    });
  });

  describe("#update", () => {
    const options = {"name":"updated value"};

    it("should update an existing customer ", async () => {
      const customerUpdated = await thisService.Model.findByIdAndUpdate(
        customerCreated._id, 
        options, 
        { new: true } // Ensure it returns the updated doc
      );
      assert.strictEqual(customerUpdated.name, options.name);
    });
  });

  describe("#delete", async () => {
    it("should delete a customer", async () => {

      ;

      const customerDeleted = await thisService.Model.findByIdAndDelete(customerCreated._id);
      assert.strictEqual(customerDeleted._id.toString(), customerCreated._id.toString());
    });
  });
});