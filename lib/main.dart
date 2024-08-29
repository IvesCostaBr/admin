import 'package:core_dashboard/common/app_config.dart';
import 'package:core_dashboard/common/dio.dart';
import 'package:core_dashboard/common/injectables.dart';
import 'package:core_dashboard/common/routes.dart';
import 'package:core_dashboard/common/routes_config.dart';
import 'package:core_dashboard/pages/authentication/sign_in_page.dart';
import 'package:core_dashboard/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    // FirebaseService().initialize();

    // try{
    //   final urlApi = await ConsumerRepository().getConsumerById('h5IV6RD5tijWSCsKOcwb');
    // }catch (e){
    //   print(e);
    // }
    

    await dotenv.load(fileName: ".env");

    AppConfig.initialize(AppConfig(
      apiBaseUrl: dotenv.env['API_BASE_URL'] ?? 'https://api.onlinerifas.pro',
      authUrl: dotenv.env['AUTH_URL'] ?? 'https://api.onlinerifas.pro',
      websocketBaseUrl: dotenv.env['WEBSOCKET_BASE_URL'] ?? 'wss://api.onlinerifas.pro'
    ));

  setupDio();
  injectDependencies();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 174, 56).withOpacity(0.4),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.redAccent),
              const SizedBox(height: 20),
              const Text(
                'Tivemos um erro!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                details.exception.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.offAllNamed(AppRouter.home);
                },
                child: const Text('Voltar para tela principal'),
              ),
            ],
          ),
        ),
      ),
    );
  };

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SignInPage(),
      theme: AppTheme.light(context), // Tema claro
      darkTheme: AppTheme.dark(context), // Tema escuro
      themeMode: ThemeMode.system,
      getPages: Routes.routes,
    );
  }
}
