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
    SystemUiOverlayStyle(
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
    final appState = Provider.of<AppState>(context);

    return MaterialApp(
      navigatorKey: OneSignalService.navigatorKey,
      title: 'Aegis - US Asset & Liabilities Radar',
      debugShowCheckedModeBanner: false,
      themeMode: appState.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      builder: (context, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final maxWidth = screenWidth >= 720 ? 880.0 : 440.0;
        final isDark = appState.isDarkMode;
        final outerBg = isDark ? const Color(0xFF040406) : const Color(0xFFE9ECF0);

        return Scaffold(
          backgroundColor: outerBg,
          body: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              decoration: BoxDecoration(
                color: AppTheme.background,
                border: Border.symmetric(
                  vertical: BorderSide(
                    color: AppTheme.surfaceBorder.withValues(alpha: 0.6),
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black87 : const Color(0x18000000),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: child,
            ),
          ),
        );
      },
      home: const NavigationScaffold(),
    );
  }
}
