
import { faker } from "@faker-js/faker";
export default (user,count,productIds) => {
    let data = [];
    for (let i = 0; i < count; i++) {
        const fake = {
product: productIds[i % productIds.length],
qty: faker.lorem.sentence(1),
price: faker.lorem.sentence(1),

updatedBy: user._id,
createdBy: user._id
        };
        data = [...data, fake];
    }
    return data;
};
