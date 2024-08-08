import 'package:get/get.dart';

class NavigationController extends GetxController {
  var currentPage = 'home'.obs;
  var isLoading = false.obs;

  void changePage(String page) async {
    currentPage.value = page;
  }
}
