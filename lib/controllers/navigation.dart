import 'package:get/get.dart';

class NavigationController extends GetxController {
  var currentPage = 'home'.obs;
  var isLoading = false.obs;

  void changePage(String page) async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    currentPage.value = page;
    isLoading.value = false;
  }
}
