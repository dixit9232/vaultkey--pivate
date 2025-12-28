import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vaultkey/l10n/generated/app_localizations.dart';

import 'core/config/app_config.dart';
import 'core/constants/app_strings.dart';
import 'core/services/injection_container.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'firebase_options.dart';
import 'presentation/routes/app_router.dart';

/// RTL language codes
const List<String> rtlLanguages = ['ar', 'he', 'fa', 'ps', 'ur', 'ug'];

/// Main entry point for VaultKey app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark, systemNavigationBarColor: Colors.transparent, systemNavigationBarIconBrightness: Brightness.dark));

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Crashlytics (only in production)
  if (!kDebugMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // Initialize dependencies
  await initDependencies();

  // Set environment (default to development)
  ConfigProvider.setEnvironment(Environment.development);

  runApp(const VaultKeyApp());
}

/// Root application widget
class VaultKeyApp extends StatelessWidget {
  const VaultKeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,

          // Theme configuration
          theme: LightTheme.theme,
          darkTheme: DarkTheme.theme,
          themeMode: ThemeMode.system,

          // Router configuration
          routerConfig: AppRouter.router,

          // Localization configuration (85+ languages)
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,

          // Builder for global configurations
          builder: (context, child) {
            // Apply global text scaling limits for accessibility
            final mediaQuery = MediaQuery.of(context);
            final textScaler = mediaQuery.textScaler.clamp(minScaleFactor: 0.8, maxScaleFactor: 1.4);

            // Determine text direction based on locale
            final locale = Localizations.localeOf(context);
            final isRtl = rtlLanguages.contains(locale.languageCode);

            return Directionality(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              child: MediaQuery(
                data: mediaQuery.copyWith(textScaler: textScaler),
                child: child ?? const SizedBox.shrink(),
              ),
            );
          },
        );
      },
    );
  }
}
