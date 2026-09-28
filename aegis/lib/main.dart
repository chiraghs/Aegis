import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'constants/theme.dart';
import 'providers/app_state.dart';
import 'services/revenuecat_service.dart';
import 'services/onesignal_service.dart';
import 'screens/navigation_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dark navigation bar and status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize RevenueCat SDK
  await RevenueCatService.instance.initialize();

  // Initialize OneSignal Push Notification SDK
  await OneSignalService.instance.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: const AegisFintechApp(),
    ),
  );
}

class AegisFintechApp extends StatelessWidget {
  const AegisFintechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: OneSignalService.navigatorKey,
      title: 'Aegis - US Asset & Liabilities Radar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const NavigationScaffold(),
    );
  }
}
