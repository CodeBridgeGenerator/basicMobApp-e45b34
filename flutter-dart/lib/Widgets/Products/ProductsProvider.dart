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
import 'Product.dart';
import 'ProductsService.dart';

class ProductsProvider with ChangeNotifier implements DataFetchable{
  List<Product> _data = [];
  Box<Product> hiveBox = Hive.box<Product>('productsBox');
  List<Product> get data => _data;
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

  ProductsProvider() {
    loadProductsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadProductsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Product item) async {
    _isLoading = true;
    final Result result = await ProductsService(query: query).create(item);
    if (result.error == null) {
      Product? data = result.data;
      hiveBox.put(data?.id, data!);
      loadProductsFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Products",
          subClass: "Products::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Product? data = result.data;
      logger.i("Failed: creating Products::createOneAndSave, error: ${result.error}, subClass: Products::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Products",
          subClass: "Products::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await ProductsService(query: query).fetchById(id);
    if (result.error == null) {
      Product? data = result.data;
      hiveBox.put(data?.id, data!);
      loadProductsFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Products::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Products::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Products $id", 
        error: result.error, 
        subClass: "Products::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await ProductsService(query: query).fetchAll();
    if (result.error == null) {
      List<Product>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Product item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadProductsFromHive();
      return Response(
        msg: "Success: Fetched all Products",
        subClass: "Products::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Products::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Products", 
        subClass: "Products::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Product item) async {
    _isLoading = true;
    final Result result = await ProductsService().update(id, item);
    if (result.error == null) {
      Product? data = result.data;
      hiveBox.put(data?.id, data!);
      loadProductsFromHive();
      return Response(
        msg: "Success: Updated Products ${id}", 
        subClass: "Products::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Products::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Products ${id}",
        subClass: "Products::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await ProductsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadProductsFromHive();
      return Response(
          msg: "Success: deleted Products $id",
          subClass: "Products::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Products::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Products $id",
      data : { "id" : id.toString() },
      subClass: "Products::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("ProductsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Products",
          subClass: "Products::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: ProductsSchema", 
      subClass: "Products::schema",
      error: result.error);
    }
  }
}