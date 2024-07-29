import 'package:core_dashboard/common/routes_config.dart';
import 'package:core_dashboard/pages/authentication/register_page.dart';
import 'package:core_dashboard/pages/authentication/sign_in_page.dart';
import 'package:core_dashboard/pages/consumer/pages/general_config.dart';
import 'package:core_dashboard/pages/consumer/pages/pages.dart';
import 'package:core_dashboard/pages/dashboard/dashboard_page.dart';
import 'package:core_dashboard/pages/entry_point.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Routes {
  static final List<GetPage> routes = [
    GetPage(name: AppRouter.home, page: () => EntryPoint()),
    GetPage(name: AppRouter.signIn, page: () => SignInPage()),
    GetPage(name: AppRouter.signUp, page: () => const RegisterPage()),
  ];
}

final Map<String, Widget> pageRoutes = {
  "dashboard": DashboardPage(),
  "consumer-config": ConsumerGeneralConfigPage(),
  "consumer-page": const ConsumePagesConfigPage()
};