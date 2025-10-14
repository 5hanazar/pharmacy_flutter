import 'package:get/get.dart';

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'ru_RU': {
      'products': 'Товары',
      'basket': 'Корзина',
      'search': 'Поиск',
      'home': 'Главная',
      'refresh': 'Обновить',
      'add_to_basket': 'Добавить',
      'checkout': 'Оформить',
      'send_order_request': 'Отправить запрос',
      'confirm': 'Подтвердить',
      'orders': 'Запросы на заказ',
      'not_found': 'Не найдено',
    },
    'tk_TM': {
      'products': 'Harytlar',
      'basket': 'Sebet',
      'search': 'Gözle',
      'home': 'Baş sahypa',
      'refresh': 'Täzele',
      'add_to_basket': 'Sebete goş',
      'checkout': 'Sargyt et',
      'send_order_request': 'Отправить запрос',
      'confirm': 'Подтвердить',
      'orders': 'Запросы на заказ',
      'not_found': 'Не найдено',
    }
  };
}