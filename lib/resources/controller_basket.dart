import 'package:get/get.dart';
import 'package:pharmacy/data/data_source/main_api.dart';
import 'package:pharmacy/data/repository.dart';
import 'package:pharmacy/domain/data_state.dart';

class BasketController extends GetxController {
  final RepositoryImpl _repo = Get.find();
  MyState<BasketDto> basketState = MyState.loading(null);

  @override
  void onInit() {
    super.onInit();
    refreshBasket();
  }

  Future<void> refreshBasket() async {
    basketState = MyState.loading(basketState.value);
    update();
    try {
      final result = await _repo.getBasket();
      basketState = MyState.success(result);
      update();
    } on Exception catch (error, _) {
      basketState = MyState.error(basketState.value, error.toString());
      update();
    }
  }

  Future<void> postBasket(PostAdditionDto dto) async {
    //await Future.delayed(const Duration(seconds: 1));
    await _repo.postBasket(dto);
    refreshBasket();
  }

  Future<void> postCheckout(PostOrderRequestDto dto) {
    return _repo.postCheckout(dto);
  }
}