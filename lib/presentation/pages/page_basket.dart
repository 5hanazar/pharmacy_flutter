import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmacy/domain/data_state.dart';
import 'package:pharmacy/presentation/pages/page_checkout.dart';
import 'package:pharmacy/presentation/pages/page_order_requests.dart';
import 'package:pharmacy/presentation/views/view_error.dart';
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
              Get.to(() => const OrderRequestsPage(), preventDuplicates: false);
            },
            icon: const Icon(Icons.receipt_outlined),
          ),
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
                  if (controller.basketState.value != null && controller.basketState.value!.products.isNotEmpty) ...[
                    SliverList.separated(
                      itemCount: controller.basketState.value!.products.length,
                      itemBuilder: (context, i) {
                        return ProductRow(product: controller.basketState.value!.products[i]);
                      },
                      separatorBuilder: (context, i) {
                        return const SizedBox(height: 8);
                      },
                    )
                  ] else if (controller.basketState.value != null) ...[
                      SliverToBoxAdapter(child: Lottie.asset('assets/empty_basket.json', width: 180, height: 180, reverse: true, frameRate: const FrameRate(60))),
                  ]
                ],
              );
            }))
    );
  }
}
