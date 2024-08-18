import 'package:core_dashboard/common/dio.dart';
import 'package:core_dashboard/controllers/auth.dart';
import 'package:core_dashboard/controllers/chat.dart';
import 'package:core_dashboard/controllers/config.dart';
import 'package:core_dashboard/controllers/event.dart';
import 'package:core_dashboard/controllers/fee.dart';
import 'package:core_dashboard/controllers/navigation.dart';
import 'package:core_dashboard/controllers/transaction.dart';
import 'package:core_dashboard/controllers/user.dart';
import 'package:core_dashboard/providers/user.dart';
import 'package:get/get.dart';

injectDependencies(){
  Get.put(UserProvider());
  Get.put(AuthService(dio));
  Get.put(ConfigController(dio));
  Get.put(ChatService(dio));
  Get.put(UserService(dio));
  Get.put(TransactionService(dio));
  Get.put(NavigationController());
  Get.put(FeeService(dio));
  Get.put(EventService(dio));
}