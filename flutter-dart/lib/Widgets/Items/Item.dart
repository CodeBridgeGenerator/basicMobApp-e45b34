import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../Products/Product.dart';
 
 
part 'Item.g.dart';
 
@HiveType(typeId: 104)

class Item {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final Product product;
	@HiveField(2)
	 
	final int? qty;
	@HiveField(3)
	 
	final int? price;

  Item({
    this.id,
		required this.product,
		this.qty,
		this.price
  });

  factory Item.fromJson(Map<String, dynamic> map) {
    return Item(
      id: map['_id'] as String?,
			product : Product.fromJson(map['product']),
			qty : map['qty'] as int,
			price : map['price'] as int
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"product" : product.id.toString(),
			"qty" : qty,
			"price" : price
    };
}

  @override
  String toString() => 'Item("_id" : $id,"product": $product.toString(),"qty": $qty,"price": $price)';
}