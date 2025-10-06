import 'package:pharmacy/data/data_source/main_api.dart';
import 'package:pharmacy/domain/repository.dart';

class RepositoryImpl implements Repository {
  final MainApi _apiMain;

  RepositoryImpl(this._apiMain);

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
  Future<num> postBasket(PostAdditionDto dto) {
    return _apiMain.postBasket(dto);
  }

  @override
  Future<void> postCheckout(PostOrderRequestDto dto) {
    return _apiMain.postCheckout(dto);
  }
}
