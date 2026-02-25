import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'ItemsList.dart';
  import 'ItemsProvider.dart';
  
  class ItemsPage extends StatelessWidget {
    const ItemsPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => ItemsProvider(),
          child: MaterialApp(title: 'Items ', home: ItemsList()));
    }
  }