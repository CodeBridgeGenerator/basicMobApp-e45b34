import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'ProductsList.dart';
  import 'ProductsProvider.dart';
  
  class ProductsPage extends StatelessWidget {
    const ProductsPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => ProductsProvider(),
          child: MaterialApp(title: 'Products ', home: ProductsList()));
    }
  }