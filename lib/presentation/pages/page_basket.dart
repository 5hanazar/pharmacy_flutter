import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/data/data_source/main_api.dart';
import 'package:pharmacy/presentation/views/row_product.dart';
import 'package:pharmacy/resources/controller_basket.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({super.key});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  final BasketController controller = Get.find();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> refreshList() async {
    await controller.refreshBasket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("basket".tr, style: const TextStyle(fontWeight: FontWeight.bold))),
        body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: refreshList,
            backgroundColor: Colors.white,
            child: GetBuilder<BasketController>(builder: (controller) {
              return BasketListView(data: controller.basketState.value!);
            }))
    );
  }
}

class BasketListView extends StatelessWidget {
  final BasketDto data;

  const BasketListView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: data.products.length,
      itemBuilder: (context, i) {
        return ProductRow(product: data.products[i]);
      },
      separatorBuilder: (context, i) {
        return const SizedBox(height: 10.0);
      },
    );
  }
}
