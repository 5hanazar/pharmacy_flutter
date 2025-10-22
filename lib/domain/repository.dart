import 'package:pharmacy/data/data_source/main_api.dart';

abstract class Repository {
  Future<PagedProductDto> getProducts(int page, String groupCode, String sortBy, String query);
  Future<ProductAndSimilarDto> getProductById(int id);
  Future<HomeDto> getHome();
  Future<BasketDto> getBasket();
  Future<PagedOrderRequestDto> getOrderRequests();
  Future<num> postBasket(PostAdditionDto dto);
  Future<void> postCheckout(PostOrderRequestDto dto);
  Future<void> deleteOrderRequest(int id);
  Future<void> setLanguage(int lang);
}