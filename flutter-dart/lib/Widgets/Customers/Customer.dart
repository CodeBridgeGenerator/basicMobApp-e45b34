import 'dart:convert';
import 'package:hive/hive.dart';
 
 
 
part 'Customer.g.dart';
 
@HiveType(typeId: 103)

class Customer {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String name;

  Customer({
    this.id,
		required this.name
  });

  factory Customer.fromJson(Map<String, dynamic> map) {
    return Customer(
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
  String toString() => 'Customer("_id" : $id,"name": $name.toString())';
}