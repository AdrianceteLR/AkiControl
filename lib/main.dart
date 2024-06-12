// ignore_for_file: depend_on_referenced_packages

import 'package:akicontrol/appRoutes.dart';
import 'package:akicontrol/models/models.dart';
import 'package:akicontrol/screens/screens.dart';
import 'package:akicontrol/services/services.dart';
import 'package:akicontrol/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(AppState()));
}

class AppState extends StatelessWidget {
  final initialProduct = Product(
    id: null,
    name: '',
    available: false,
    category: '',
    quantity: 0,
    store: '',
  );

  final initialStore = Store(
    name: '',
    country: '',
  );

  final initialTask = Task(
    finish: false,
    title: '',
    description: '',
    day: '',
  );

  AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ProductsService()),
        ChangeNotifierProvider(
            create: (_) => ProductFormProvider(initialProduct)),
        ChangeNotifierProvider(create: (_) => StoresService()),
        ChangeNotifierProvider(create: (_) => StoreFormProvider(initialStore)),
        ChangeNotifierProvider(create: (_) => TasksService()),
        ChangeNotifierProvider(create: (_) => TaskFormProvider(initialTask)),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: CheckAuthScreen.routeName,
      routes: appRoutes,
      scaffoldMessengerKey: NotificationsService.messengerKey,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'),
      ],
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey.shade300,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            color: Color(0xFFE76F51),
            foregroundColor: Colors.white,
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: const Color(0xFFE76F51),
            contentTextStyle:
                const TextStyle(color: Colors.white, fontSize: 22),
            actionTextColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: Color(0xFFE76F51),
              ),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFFF4A261),
            iconSize: 35,
            foregroundColor: Colors.white,
          ),
          switchTheme: SwitchThemeData(
            thumbColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return Colors.white;
              },
            ),
            trackColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return const Color(0xFFF4A261);
                }
                return Colors.grey;
              },
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 40,
          )),
    );
  }
}
