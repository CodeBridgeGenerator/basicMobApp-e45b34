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
import 'Item.dart';
import 'ItemsService.dart';

class ItemsProvider with ChangeNotifier implements DataFetchable{
  List<Item> _data = [];
  Box<Item> hiveBox = Hive.box<Item>('itemsBox');
  List<Item> get data => _data;
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
      "path": "product",
      "service": "products",
      "select": [
        "name"
      ]
    }
  ]
};

  ItemsProvider() {
    loadItemsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadItemsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Item item) async {
    _isLoading = true;
    final Result result = await ItemsService(query: query).create(item);
    if (result.error == null) {
      Item? data = result.data;
      hiveBox.put(data?.id, data!);
      loadItemsFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Items",
          subClass: "Items::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Item? data = result.data;
      logger.i("Failed: creating Items::createOneAndSave, error: ${result.error}, subClass: Items::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Items",
          subClass: "Items::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await ItemsService(query: query).fetchById(id);
    if (result.error == null) {
      Item? data = result.data;
      hiveBox.put(data?.id, data!);
      loadItemsFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Items::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Items::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Items $id", 
        error: result.error, 
        subClass: "Items::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await ItemsService(query: query).fetchAll();
    if (result.error == null) {
      List<Item>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Item item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadItemsFromHive();
      return Response(
        msg: "Success: Fetched all Items",
        subClass: "Items::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Items::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Items", 
        subClass: "Items::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Item item) async {
    _isLoading = true;
    final Result result = await ItemsService().update(id, item);
    if (result.error == null) {
      Item? data = result.data;
      hiveBox.put(data?.id, data!);
      loadItemsFromHive();
      return Response(
        msg: "Success: Updated Items ${id}", 
        subClass: "Items::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Items::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Items ${id}",
        subClass: "Items::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await ItemsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadItemsFromHive();
      return Response(
          msg: "Success: deleted Items $id",
          subClass: "Items::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Items::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Items $id",
      data : { "id" : id.toString() },
      subClass: "Items::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("ItemsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Items",
          subClass: "Items::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: ItemsSchema", 
      subClass: "Items::schema",
      error: result.error);
    }
  }
}