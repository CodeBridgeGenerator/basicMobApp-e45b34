import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../CBWidgets/Profiles/ProfilesProvider.dart';
import '../CBWidgets/Profiles/Profile.dart';
import '../App/MenuBottomBar/Inbox/Inbox.dart';
import '../App/MenuBottomBar/Inbox/InboxProvider.dart';
import '../App/Dash/Notifications/CBNotification.dart';
import '../App/Dash/Notifications/NotificationProvider.dart';
import './Services/IdName.dart';

import '../Widgets/Products/Product.dart';
import '../Widgets/Orders/Order.dart';
import '../Widgets/Customers/Customer.dart';
import '../Widgets/Items/Item.dart';
// ~cb-add-service-imports~

import '../Widgets/Products/ProductsProvider.dart';
import '../Widgets/Orders/OrdersProvider.dart';
import '../Widgets/Customers/CustomersProvider.dart';
import '../Widgets/Items/ItemsProvider.dart';
// ~cb-add-provider-imports~

class HiveSetup {
  static Future<void> initializeHive() async {
    // Initialize Hive
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(ProductAdapter());
    }
            
    if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(OrderAdapter());
    }
            
    if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter(CustomerAdapter());
    }
            
    if (!Hive.isAdapterRegistered(4)) {
        Hive.registerAdapter(ItemAdapter());
    }
            
    // ~cb-add-service-adapters~

    if (!Hive.isBoxOpen('productsBox')) {
        await Hive.openBox<Product>('productsBox');
    }
            
    if (!Hive.isBoxOpen('ordersBox')) {
        await Hive.openBox<Order>('ordersBox');
    }
            
    if (!Hive.isBoxOpen('customersBox')) {
        await Hive.openBox<Customer>('customersBox');
    }
            
    if (!Hive.isBoxOpen('itemsBox')) {
        await Hive.openBox<Item>('itemsBox');
    }
            
    // ~cb-add-hivebox~
  }

  List<SingleChildWidget> providers() {
    return [
         ChangeNotifierProvider(create: (_) => ProductsProvider()),
         ChangeNotifierProvider(create: (_) => OrdersProvider()),
         ChangeNotifierProvider(create: (_) => CustomersProvider()),
         ChangeNotifierProvider(create: (_) => ItemsProvider()),
      // ~cb-add-notifier~
    ];
  }
}
