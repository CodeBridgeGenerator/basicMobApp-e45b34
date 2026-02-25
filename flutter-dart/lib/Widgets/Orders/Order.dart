import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../Customers/Customer.dart';
import '../Items/Item.dart';
 
 
part 'Order.g.dart';
 
@HiveType(typeId: 102)

class Order {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String orderNumber;
	@HiveField(2)
	 
	final Customer? customer;
	@HiveField(3)
	 
	final List<Item>? items;

  Order({
    this.id,
		required this.orderNumber,
		this.customer,
		this.items
  });

  factory Order.fromJson(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] as String?,
			orderNumber : map['orderNumber'] as String,
			customer : map['customer'] != null ? Customer.fromJson(map['customer']) : null,
			items : map['items'] != null ? (map['items'] as List).map((e) => Item.fromJson(e)).toList() : null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"customer" : customer?.id.toString(),
			"items" : items?.map((e) => e.toJson()).toList()
    };
}

  @override
  String toString() => 'Order("_id" : $id,"orderNumber": $orderNumber.toString(),"customer": $customer.toString(),"items": $items.toString())';
}