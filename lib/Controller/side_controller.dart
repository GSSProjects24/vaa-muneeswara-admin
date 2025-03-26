import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SideDrawerController extends GetxController {
  var selectedIndex = 0.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    selectedIndex.value = box.read('selectedIndex') ?? 0;
  }

  void changePage(int index) {
    selectedIndex.value = index;
    box.write('selectedIndex', index);  // Save selected index
  }
}
