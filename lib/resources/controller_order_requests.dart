import 'package:get/get.dart';
import 'package:pharmacy/data/data_source/main_api.dart';
import 'package:pharmacy/data/repository.dart';
import 'package:pharmacy/domain/data_state.dart';

class OrderRequestsController extends GetxController {
  final RepositoryImpl _repo = Get.find();
  MyState<PagedOrderRequestDto> orderRequestsState = MyState.loading(null);

  @override
  void onInit() {
    super.onInit();
    refreshOrderRequests();
  }

  Future<void> refreshOrderRequests() async {
    orderRequestsState = MyState.loading(orderRequestsState.value);
    update();
    try {
      final result = await _repo.getOrderRequests();
      orderRequestsState = MyState.success(result);
      update();
    } on Exception catch (error, _) {
      orderRequestsState = MyState.error(orderRequestsState.value, error.toString());
      update();
    }
  }

  Future<void> deleteOrderRequest(int id) async {
    await _repo.deleteOrderRequest(id);
    refreshOrderRequests();
  }
}