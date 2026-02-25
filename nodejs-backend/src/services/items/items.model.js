
    module.exports = function (app) {
        const modelName = "items";
        const mongooseClient = app.get("mongooseClient");
        const { Schema } = mongooseClient;
        const schema = new Schema(
          {
            product: { type: Schema.Types.ObjectId, ref: "products", comment: "Product, dropdown, false, true, true, true, true, true, true, products, products, one-to-one, name," },
qty: { type: Number, max: 10000000, comment: "Qty, p_number, false, true, true, true, true, true, true, , , , ," },
price: { type: Number, max: 10000000, comment: "Price, currency, false, true, true, true, true, true, true, , , , ," },

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