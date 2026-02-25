import '../../Utils/Services/CrudService.dart';
import 'Product.dart';

class ProductsService extends CrudService<Product> {
  ProductsService({String? query = ""})
      : super(
    'products', // Endpoint for external tickets
    query,
    fromJson: (json) => Product.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
