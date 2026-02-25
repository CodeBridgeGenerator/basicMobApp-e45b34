import 'dart:convert';
import 'package:hive/hive.dart';
 
 
 
part 'Product.g.dart';
 
@HiveType(typeId: 101)

class Product {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String name;

  Product({
    this.id,
		required this.name
  });

  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
      id: map['_id'] as String?,
			name : map['name'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id
    };
}

  @override
  String toString() => 'Product("_id" : $id,"name": $name.toString())';
}