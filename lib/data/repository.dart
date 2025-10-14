import 'package:pharmacy/data/data_source/main_api.dart';
import 'package:pharmacy/domain/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepositoryImpl implements Repository {
  final SharedPreferences _prefs;
  final MainApi _apiMain;

  RepositoryImpl(this._prefs, this._apiMain);

  @override
  Future<PagedProductDto> getProducts(int page, String groupCode, String query) {
    return _apiMain.getProducts(page, groupCode, query);
  }

  @override
  Future<HomeDto> getHome() {
    return _apiMain.getHome();
  }

  @override
  Future<BasketDto> getBasket() {
    return _apiMain.getBasket();
  }

  @override
  Future<PagedOrderRequestDto> getOrderRequests() {
    return _apiMain.getOrderRequests();
  }

  @override
  Future<num> postBasket(PostAdditionDto dto) {
    return _apiMain.postBasket(dto);
  }

  @override
  Future<void> postCheckout(PostOrderRequestDto dto) {
    return _apiMain.postCheckout(dto);
  }

  @override
  Future<void> deleteOrderRequest(int id) {
    return _apiMain.deleteOrderRequest(id);
  }

  @override
  Future<void> setLanguage(int lang) {
    return _prefs.setInt("lang", lang);
  }
}
