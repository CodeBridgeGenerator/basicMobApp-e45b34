
    module.exports = function (app) {
        const modelName = "mail_ques";
        const mongooseClient = app.get("mongooseClient");
        const { Schema } = mongooseClient;
        const schema = new Schema(
          {
            name: { type:  String , comment: "Name, p, false, true, true, true, true, true, true, , , , ," },
from: { type:  String , comment: "From, p, false, true, true, true, true, true, true, , , , ," },
subject: { type:  String , comment: "Subject, p, false, true, true, true, true, true, true, , , , ," },
recipients: { type: String , enum: ["A","B","C","D"], comment: "Recipients, dropdownArray, false, true, true, true, true, true, true, , , , ," },
content: { type:  String , comment: "Content, editor, false, true, true, true, true, true, true, , , , ," },
payload: { type: Schema.Types.Mixed , comment: "payload, pre, false, true, true, true, true, true, true, , , , ," },
templateId: { type:  String , comment: "template Id, p, false, true, true, true, true, true, true, , , , ," },
status: { type: Boolean, required: false, comment: "Status, p_boolean, false, true, true, true, true, true, true, , , , ," },
jobId: { type: Number, max: 10000000, comment: "JobId, p_number, false, true, true, true, true, true, true, , , , ," },
end: { type: Date, comment: "End, calendar_12, false, true, true, true, true, true, true, , , , ," },

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