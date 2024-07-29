import 'package:core_dashboard/common/app_config.dart';
import 'package:core_dashboard/common/dio.dart';
import 'package:core_dashboard/common/injectables.dart';
import 'package:core_dashboard/common/routes.dart';
import 'package:core_dashboard/pages/authentication/sign_in_page.dart';
import 'package:core_dashboard/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");

    AppConfig.initialize(AppConfig(
      apiBaseUrl: dotenv.env['API_BASE_URL'] ?? '',
      authUrl: dotenv.env['AUTH_URL'] ?? '',
      websocketBaseUrl: dotenv.env['WEBSOCKET_BASE_URL'] ?? ''
    ));

  setupDio();
  injectDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SignInPage(),
      theme: AppTheme.light(context),
      // darkTheme: AppTheme.dark(context),
      getPages: Routes.routes,
    );
  }
}
