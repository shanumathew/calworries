import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calworries/core/services/hive_service.dart';
import 'package:calworries/core/theme/app_theme.dart';
import 'package:calworries/shared/providers/meal_provider.dart';
import 'package:calworries/shared/providers/shopping_provider.dart';
import 'package:calworries/shared/providers/spending_provider.dart';
import 'package:calworries/features/analytics/presentation/screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MealProvider()),
        ChangeNotifierProvider(create: (_) => ShoppingProvider()),
        ChangeNotifierProvider(create: (_) => SpendingProvider()),
      ],
      child: MaterialApp(
        title: 'Calworries',
        theme: AppTheme.lightTheme(),
        home: const DashboardScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
