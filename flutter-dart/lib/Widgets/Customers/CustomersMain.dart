import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'CustomersList.dart';
  import 'CustomersProvider.dart';
  
  class CustomersPage extends StatelessWidget {
    const CustomersPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => CustomersProvider(),
          child: MaterialApp(title: 'Customers ', home: CustomersList()));
    }
  }