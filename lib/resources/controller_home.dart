import 'package:get/get.dart';
import 'package:pharmacy/data/data_source/main_api.dart';
import 'package:pharmacy/data/repository.dart';
import 'package:pharmacy/domain/data_state.dart';

class HomeController extends GetxController {
  final RepositoryImpl _repo = Get.find();
  MyState<HomeDto> homeState = MyState.loading(null);

  @override
  void onInit() {
    super.onInit();
    refreshHome();
  }

  Future<void> refreshHome() async {
    homeState = MyState.loading(homeState.value);
    update();
    try {
      final result = await _repo.getHome();
      homeState = MyState.success(result);
      update();
    } on Exception catch (error, _) {
      homeState = MyState.error(homeState.value, error.toString());
      update();
    }
  }
}