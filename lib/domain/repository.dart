import 'package:pharmacy/data/data_source/main_api.dart';

abstract class Repository {
  Future<PagedProductDto> getProducts(int page, String groupCode, String query);
  Future<HomeDto> getHome();
  Future<BasketDto> getBasket();
  Future<PagedOrderRequestDto> getOrderRequests();
  Future<num> postBasket(PostAdditionDto dto);
  Future<void> postCheckout(PostOrderRequestDto dto);
}