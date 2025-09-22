import 'package:pharmacy/data/data_source/main_api.dart';

abstract class Repository {
  Future<PagedProductDto> getProducts(int page, String query);
  Future<HomeDto> getHome();
}