
    module.exports = function (app) {
        const modelName = "orders";
        const mongooseClient = app.get("mongooseClient");
        const { Schema } = mongooseClient;
        const schema = new Schema(
          {
            orderNumber: { type:  String , required: true, comment: "Order Number, p, false, true, true, true, true, true, true, , , , ," },
customer: { type: Schema.Types.ObjectId, ref: "customers", comment: "Customer, dropdown, false, true, true, true, true, true, true, customers, customers, one-to-one, name," },
items: { type: [Schema.Types.ObjectId], ref: "items", description: "isArray", comment: "Items, multiselect, false, true, true, true, true, true, true, items, items, one-to-many, orderNumber:customer," },

            createdBy: { type: Schema.Types.ObjectId, ref: "users", required: true },
            updatedBy: { type: Schema.Types.ObjectId, ref: "users", required: true }
          },
          {
            timestamps: true
        });
      
       
        if (mongooseClient.modelNames().includes(modelName)) {
          mongooseClient.deleteModel(modelName);
        }
        return mongooseClient.model(modelName, schema);
        
      };