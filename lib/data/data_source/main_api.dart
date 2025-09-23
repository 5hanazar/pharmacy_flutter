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
}

class PagedProductDto {
  int count;
  List<ProductDto> data;
  int size;
  int pageIndex;
  String groupName;

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
  int id;
  String barcode;
  String name;
  String description;
  String groupName;
  num price;
  List<String> images;

  ProductDto(
      {required this.id,
        required this.barcode,
        required this.name,
        required this.description,
        required this.groupName,
        required this.price,
        required this.images});

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
        id: json['id'],
        barcode: json['barcode'],
        name: json['name'],
        description: json['description'],
        groupName: json['groupName'],
        price: json['price'],
        images: List<String>.from(json['images']));
  }
}

class CategoryDto {
  int id;
  String code;
  String name;
  String description;

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