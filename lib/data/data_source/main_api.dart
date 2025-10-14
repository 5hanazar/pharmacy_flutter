import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

const base = "http://10.0.2.2:5173";

class MainApi {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      validateStatus: (status) => true,
    ),
  );
  final SharedPreferences prefs;
  MainApi({required this.prefs});

  Future<T> _fetch<T>(String url, final T Function(Map<String, dynamic> json) converter) async {
    final response = await dio.get(
      "$base$url",
      options: Options(
        headers: {
          'Accept': "application/json",
          'Cookie': "l=2;${prefs.getString("pharmacy_user") ?? ""}",
        },
      ),
    );
    if (response.statusCode == 200) {
      if (response.headers["set-cookie"] != null) {
        final cookie = (response.headers["set-cookie"]!.first).replaceAll(RegExp(r'^\[|\]$'), '');
        await prefs.setString('pharmacy_user', cookie);
      }
      return converter(jsonDecode(response.toString()));
    } else {
      throw Exception('${response.statusCode}');
    }
  }

  Future<PagedProductDto> getProducts(int page, String groupCode, String query) {
    return _fetch<PagedProductDto>('/products?p=$page&g=$groupCode&q=$query', PagedProductDto.fromJson);
  }
  Future<HomeDto> getHome() {
    return _fetch<HomeDto>('/', HomeDto.fromJson);
  }
  Future<BasketDto> getBasket() {
    return _fetch<BasketDto>('/basket', BasketDto.fromJson);
  }
  Future<PagedOrderRequestDto> getOrderRequests() {
    return _fetch<PagedOrderRequestDto>('/orders', PagedOrderRequestDto.fromJson);
  }

  Future<num> postBasket(PostAdditionDto dto) async {
    final response = await dio.post(
      '$base/basket',
      data: jsonEncode(dto),
      options: Options(
          headers: {
            'Accept': "text/plain",
            "Content-Type": "application/json",
            'Cookie': "l=2;${prefs.getString("pharmacy_user") ?? ""}",
          }
      ),
    );
    if (response.statusCode == 200) {
      return num.parse(response.toString());
    } else {
      throw Exception('${response.statusCode}');
    }
  }

  Future<void> postCheckout(PostOrderRequestDto dto) async {
    final response = await dio.post(
      '$base/checkout',
      data: FormData.fromMap({
        'data': jsonEncode(dto),
      }),
      options: Options(
          headers: {
            'Accept': "application/json",
            "Content-Type": "multipart/form-data",
            'Cookie': "l=2;${prefs.getString("pharmacy_user") ?? ""}",
          }
      ),
    );
    if (response.statusCode != 200) {
      throw Exception('${response.statusCode}');
    }
  }
}

class PagedProductDto {
  final int count;
  final List<ProductDto> data;
  final int size;
  final int pageIndex;
  final String groupName;

  PagedProductDto({required this.count, required this.data, required this.size, required this.pageIndex, required this.groupName});

  factory PagedProductDto.fromJson(Map<String, dynamic> json) {
    var data = <ProductDto>[];
    json['data'].forEach((v) {
      data.add(ProductDto.fromJson(v));
    });
    return PagedProductDto(count: json['count'], data: data, size: json['size'], pageIndex: json['pageIndex'], groupName: json['groupName']);
  }
}

class ProductDto {
  final int id;
  final String barcode;
  final String name;
  final String description;
  final String groupName;
  final num price;
  final num inBasket;
  final bool isFavorite;
  final List<String> images;

  ProductDto(
      {required this.id,
        required this.barcode,
        required this.name,
        required this.description,
        required this.groupName,
        required this.price,
        required this.inBasket,
        required this.isFavorite,
        required this.images});

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
        id: json['id'],
        barcode: json['barcode'],
        name: json['name'],
        description: json['description'],
        groupName: json['groupName'],
        price: json['price'],
        inBasket: json['inBasket'],
        isFavorite: json['isFavorite'],
        images: List<String>.from(json['images']));
  }
}

class CategoryDto {
  final int id;
  final String code;
  final String name;
  final String description;

  CategoryDto(
      {required this.id,
        required this.code,
        required this.name,
        required this.description});

  factory CategoryDto.fromJson(Map<String, dynamic> json) {
    return CategoryDto(
        id: json['id'],
        code: json['code'],
        name: json['name'],
        description: json['description']);
  }
}

class PostAdditionDto {
  final int productId;
  final num addition;

  PostAdditionDto(
      {required this.productId,
        required this.addition});

  factory PostAdditionDto.fromJson(Map<String, dynamic> json) {
    return PostAdditionDto(
        productId: json['productId'],
        addition: json['addition']);
  }

  Map<String, dynamic> toJson() => {'productId': productId, 'addition': addition};
}

class RowDto {
  final String code;
  final String title;
  final List<ProductDto> products;

  RowDto({
    required this.code,
    required this.title,
    required this.products,
  });

  factory RowDto.fromJson(Map<String, dynamic> json) {
    var products = <ProductDto>[];
    if (json['products'] != null) {
      json['products'].forEach((v) {
        products.add(ProductDto.fromJson(v));
      });
    }
    return RowDto(
      code: json['code'],
      title: json['title'],
      products: products,
    );
  }
}

class HomeDto {
  final List<CategoryDto> categories;
  final List<RowDto> list;

  HomeDto({
    required this.categories,
    required this.list,
  });

  factory HomeDto.fromJson(Map<String, dynamic> json) {
    var categories = <CategoryDto>[];
    if (json['categories'] != null) {
      json['categories'].forEach((v) {
        categories.add(CategoryDto.fromJson(v));
      });
    }
    var list = <RowDto>[];
    if (json['list'] != null) {
      json['list'].forEach((v) {
        list.add(RowDto.fromJson(v));
      });
    }
    return HomeDto(
      categories: categories,
      list: list,
    );
  }
}

class BasketDto {
  final num total;
  final List<ProductDto> products;

  BasketDto({
    required this.total,
    required this.products,
  });

  factory BasketDto.fromJson(Map<String, dynamic> json) {
    var products = <ProductDto>[];
    if (json['products'] != null) {
      json['products'].forEach((v) {
        products.add(ProductDto.fromJson(v));
      });
    }
    return BasketDto(
      total: json['total'],
      products: products,
    );
  }
}

class PagedOrderRequestDto {
  final int count;
  final List<OrderRequestDtoView> data;
  final int size;
  final int pageIndex;

  PagedOrderRequestDto({required this.count, required this.data, required this.size, required this.pageIndex});

  factory PagedOrderRequestDto.fromJson(Map<String, dynamic> json) {
    var data = <OrderRequestDtoView>[];
    json['data'].forEach((v) {
      data.add(OrderRequestDtoView.fromJson(v));
    });
    return PagedOrderRequestDto(count: json['count'], data: data, size: json['size'], pageIndex: json['pageIndex']);
  }
}

class PostOrderRequestDto {
  final String clientName;
  final String phoneToContact;
  final String address;
  final String description;

  PostOrderRequestDto(
      {required this.clientName,
        required this.phoneToContact,
        required this.address,
        required this.description});

  factory PostOrderRequestDto.fromJson(Map<String, dynamic> json) {
    return PostOrderRequestDto(
        clientName: json['clientName'],
        phoneToContact: json['phoneToContact'],
        address: json['address'],
        description: json['description']);
  }

  Map<String, dynamic> toJson() => {'clientName': clientName, 'phoneToContact': phoneToContact, 'address': address, 'description': description};
}

class OrderRequestLineDtoView {
  final String barcode;
  final String name;
  final String description;
  final num price;
  final num quantity;

  OrderRequestLineDtoView({
    required this.barcode,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
  });

  factory OrderRequestLineDtoView.fromJson(Map<String, dynamic> json) {
    return OrderRequestLineDtoView(
      barcode: json['barcode'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }
}

class OrderRequestDtoView {
  final String phone;
  final String address;
  final String description;
  final List<OrderRequestLineDtoView> lines;
  final num total;
  final String createdDate;

  OrderRequestDtoView({
    required this.phone,
    required this.address,
    required this.description,
    required this.lines,
    required this.total,
    required this.createdDate,
  });

  factory OrderRequestDtoView.fromJson(Map<String, dynamic> json) {
    var lines = <OrderRequestLineDtoView>[];
    if (json['lines'] != null) {
      json['lines'].forEach((v) {
        lines.add(OrderRequestLineDtoView.fromJson(v));
      });
    }

    return OrderRequestDtoView(
      phone: json['phone'],
      address: json['address'],
      description: json['description'],
      lines: lines,
      total: json['total'],
      createdDate: json['createdDate'],
    );
  }
}