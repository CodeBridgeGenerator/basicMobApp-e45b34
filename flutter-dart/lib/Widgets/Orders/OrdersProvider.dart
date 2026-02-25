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
import 'Order.dart';
import 'OrdersService.dart';

class OrdersProvider with ChangeNotifier implements DataFetchable{
  List<Order> _data = [];
  Box<Order> hiveBox = Hive.box<Order>('ordersBox');
  List<Order> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late final String query;
  Map<String, dynamic> mapQuery = {
  "limit": 1000,
  "\$sort": {
    "createdAt": -1
  },
  "\$populate": [
    {
      "path": "customer",
      "service": "customers",
      "select": [
        "name"
      ]
    },
    {
      "path": "items",
      "service": "items",
      "select": [
        "product",
        "qty",
        "price"
      ]
    }
  ]
};

  OrdersProvider() {
    loadOrdersFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadOrdersFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Order item) async {
    _isLoading = true;
    final Result result = await OrdersService(query: query).create(item);
    if (result.error == null) {
      Order? data = result.data;
      hiveBox.put(data?.id, data!);
      loadOrdersFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Orders",
          subClass: "Orders::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Order? data = result.data;
      logger.i("Failed: creating Orders::createOneAndSave, error: ${result.error}, subClass: Orders::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Orders",
          subClass: "Orders::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await OrdersService(query: query).fetchById(id);
    if (result.error == null) {
      Order? data = result.data;
      hiveBox.put(data?.id, data!);
      loadOrdersFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Orders::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Orders::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Orders $id", 
        error: result.error, 
        subClass: "Orders::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await OrdersService(query: query).fetchAll();
    if (result.error == null) {
      List<Order>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Order item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadOrdersFromHive();
      return Response(
        msg: "Success: Fetched all Orders",
        subClass: "Orders::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Orders::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Orders", 
        subClass: "Orders::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Order item) async {
    _isLoading = true;
    final Result result = await OrdersService().update(id, item);
    if (result.error == null) {
      Order? data = result.data;
      hiveBox.put(data?.id, data!);
      loadOrdersFromHive();
      return Response(
        msg: "Success: Updated Orders ${id}", 
        subClass: "Orders::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Orders::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Orders ${id}",
        subClass: "Orders::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await OrdersService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadOrdersFromHive();
      return Response(
          msg: "Success: deleted Orders $id",
          subClass: "Orders::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Orders::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Orders $id",
      data : { "id" : id.toString() },
      subClass: "Orders::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("OrdersSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Orders",
          subClass: "Orders::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: OrdersSchema", 
      subClass: "Orders::schema",
      error: result.error);
    }
  }
}