import '../../Utils/Services/CrudService.dart';
import 'Order.dart';

class OrdersService extends CrudService<Order> {
  OrdersService({String? query = ""})
      : super(
    'orders', // Endpoint for external tickets
    query,
    fromJson: (json) => Order.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
