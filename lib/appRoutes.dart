// ignore_for_file: file_names

import 'package:akicontrol/screens/screens.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    LoginScreen.routeName: (context) => const LoginScreen(),
    RegisterScreen.routeName: (context) => const RegisterScreen(),
    HomeScreen.routeName: (context) => const HomeScreen(),
    CheckAuthScreen.routeName: (context) => const CheckAuthScreen(),
    RegisterProduct.routeName: (context) => const RegisterProduct(),
    InventoryScreen.routeName: (context) => const InventoryScreen(),
    ProductInventoryScreen.routeName: (context) =>
        const ProductInventoryScreen(),
    StoreScreen.routeName: (context) => const StoreScreen(),
    DetailsStoreScreen.routeName: (context) => const DetailsStoreScreen(),
    StoreClientScreen.routeName: (context) => const StoreClientScreen(),
    CalendarScreen.routeName: (context) => const CalendarScreen(),
    DetailsCalendarScreen.routeName: (context) => const DetailsCalendarScreen(),
    ReportPdfScreen.routeName: (context) => const ReportPdfScreen(),
  };
}
