import 'package:core_dashboard/common/routes.dart';
import 'package:core_dashboard/controllers/auth.dart';
import 'package:core_dashboard/controllers/config.dart';
import 'package:core_dashboard/controllers/navigation.dart';
import 'package:core_dashboard/pages/dashboard/dashboard_page.dart';
import 'package:core_dashboard/providers/user.dart';
import 'package:core_dashboard/responsive.dart';
import 'package:core_dashboard/shared/widgets/header.dart';
import 'package:core_dashboard/shared/widgets/sidemenu/sidebar.dart';
import 'package:core_dashboard/shared/widgets/sidemenu/tab_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

class EntryPoint extends StatelessWidget {
  final authService = Get.find<AuthService>();
  final configController = Get.find<ConfigController>();
  final userProvider = Get.find<UserProvider>();
  
  EntryPoint({super.key}) {
    Get.put(NavigationController());  // Register the controller
  }

  final NavigationController navigationController = Get.find();

  Future<void> initConfig() async {
    var userData = userProvider.userData;
    if (userData == null){
      await authService.fetchUserData();
      userData = userProvider.userData;
    }
    await configController.fetchConfig(userData!["consumer_id"]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initConfig(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return Scaffold(
            key: _drawerKey,
            drawer: Responsive.isMobile(context) ? Sidebar() : null,
            body: Row(
              children: [
                if (Responsive.isDesktop(context)) Sidebar(),
                if (Responsive.isTablet(context)) const TabSidebar(),
                Expanded(
                  child: Column(
                    children: [
                      Header(drawerKey: _drawerKey),
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1360),
                          child: Obx(() {
                            return pageRoutes[navigationController.currentPage.value] ?? ListView(children: [DashboardPage()]);
                          }),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
