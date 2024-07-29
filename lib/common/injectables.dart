import 'package:core_dashboard/common/dio.dart';
import 'package:core_dashboard/controllers/auth.dart';
import 'package:core_dashboard/controllers/config.dart';
import 'package:core_dashboard/controllers/navigation.dart';
import 'package:core_dashboard/providers/user.dart';
import 'package:get/get.dart';

injectDependencies(){
  Get.put(UserProvider());
  Get.put(AuthService(dio));
  Get.put(ConfigController(dio));
  Get.put(NavigationController());
}