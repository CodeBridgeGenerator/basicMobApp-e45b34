import '../../Utils/Services/CrudService.dart';
import 'Item.dart';

class ItemsService extends CrudService<Item> {
  ItemsService({String? query = ""})
      : super(
    'items', // Endpoint for external tickets
    query,
    fromJson: (json) => Item.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
