import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:logger/logger.dart';
import '../../Utils/Methods.dart';
import '../../Utils/Services/SchemaService.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import '../../CBWidgets/DataInitializer/DataFetchable.dart';
import 'Customer.dart';
import 'CustomersService.dart';

class CustomersProvider with ChangeNotifier implements DataFetchable{
  List<Customer> _data = [];
  Box<Customer> hiveBox = Hive.box<Customer>('customersBox');
  List<Customer> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late final String query;
  Map<String, dynamic> mapQuery = {
  "limit": 1000,
  "\$sort": {
    "createdAt": -1
  },
  "\$populate": []
};

  CustomersProvider() {
    loadCustomersFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadCustomersFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Customer item) async {
    _isLoading = true;
    final Result result = await CustomersService(query: query).create(item);
    if (result.error == null) {
      Customer? data = result.data;
      hiveBox.put(data?.id, data!);
      loadCustomersFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Customers",
          subClass: "Customers::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Customer? data = result.data;
      logger.i("Failed: creating Customers::createOneAndSave, error: ${result.error}, subClass: Customers::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Customers",
          subClass: "Customers::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await CustomersService(query: query).fetchById(id);
    if (result.error == null) {
      Customer? data = result.data;
      hiveBox.put(data?.id, data!);
      loadCustomersFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Customers::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Customers::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Customers $id", 
        error: result.error, 
        subClass: "Customers::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await CustomersService(query: query).fetchAll();
    if (result.error == null) {
      List<Customer>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Customer item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadCustomersFromHive();
      return Response(
        msg: "Success: Fetched all Customers",
        subClass: "Customers::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Customers::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Customers", 
        subClass: "Customers::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Customer item) async {
    _isLoading = true;
    final Result result = await CustomersService().update(id, item);
    if (result.error == null) {
      Customer? data = result.data;
      hiveBox.put(data?.id, data!);
      loadCustomersFromHive();
      return Response(
        msg: "Success: Updated Customers ${id}", 
        subClass: "Customers::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Customers::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Customers ${id}",
        subClass: "Customers::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await CustomersService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadCustomersFromHive();
      return Response(
          msg: "Success: deleted Customers $id",
          subClass: "Customers::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Customers::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Customers $id",
      data : { "id" : id.toString() },
      subClass: "Customers::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("CustomersSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Customers",
          subClass: "Customers::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: CustomersSchema", 
      subClass: "Customers::schema",
      error: result.error);
    }
  }
}