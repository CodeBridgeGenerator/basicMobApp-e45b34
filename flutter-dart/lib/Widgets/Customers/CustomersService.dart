import '../../Utils/Services/CrudService.dart';
import 'Customer.dart';

class CustomersService extends CrudService<Customer> {
  CustomersService({String? query = ""})
      : super(
    'customers', // Endpoint for external tickets
    query,
    fromJson: (json) => Customer.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
