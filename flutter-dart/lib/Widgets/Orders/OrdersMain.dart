import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'OrdersList.dart';
  import 'OrdersProvider.dart';
  
  class OrdersPage extends StatelessWidget {
    const OrdersPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => OrdersProvider(),
          child: MaterialApp(title: 'Orders ', home: OrdersList()));
    }
  }