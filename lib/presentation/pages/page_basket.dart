import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/domain/data_state.dart';
import 'package:pharmacy/presentation/pages/page_checkout.dart';
import 'package:pharmacy/presentation/views/error_view.dart';
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
        appBar: AppBar(title: Text("basket".tr, style: const TextStyle(fontWeight: FontWeight.bold)), actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const CheckoutPage(), preventDuplicates: false);
            },
            icon: const Icon(Icons.check),
          )
        ]),
        body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: refreshList,
            backgroundColor: Colors.white,
            child: GetBuilder<BasketController>(builder: (controller) {
              return CustomScrollView(
                slivers: [
                  if (controller.basketState is MyErrorState) ...[
                    SliverToBoxAdapter(child: ErrorView(state: controller.basketState as MyErrorState)),
                  ],
                  if (controller.basketState.value != null) ...[
                    SliverList.separated(
                      itemCount: controller.basketState.value!.products.length,
                      itemBuilder: (context, i) {
                        return ProductRow(product: controller.basketState.value!.products[i]);
                      },
                      separatorBuilder: (context, i) {
                        return const SizedBox(height: 10.0);
                      },
                    )
                  ],
                ],
              );
            }))
    );
  }
}
