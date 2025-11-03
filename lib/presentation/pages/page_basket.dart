import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmacy/domain/data_state.dart';
import 'package:pharmacy/presentation/pages/page_checkout.dart';
import 'package:pharmacy/presentation/views/view_error.dart';
import 'package:pharmacy/presentation/views/row_product.dart';
import 'package:pharmacy/resources/controller_basket.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({super.key});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BasketController>(builder: (controller) {
      final double textScaleFactor = MediaQuery.of(context).textScaler.scale(1);
      return Scaffold(
          appBar: AppBar(title: Text("basket".tr, style: const TextStyle(fontWeight: FontWeight.bold)), actions: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${"approximate_total".tr}:", style: const TextStyle(fontSize: 12)),
                  Row(
                    children: [
                      Text("~${controller.basketState.value?.total ?? 0} ", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 1.2)),
                      const Text("TMT", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ], toolbarHeight: 56 * textScaleFactor),
          body: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () => controller.refreshBasket(),
              backgroundColor: Colors.white,
              child: Stack(
                children: [
                  if (controller.basketState.value != null && controller.basketState.value!.products.isEmpty) ...[
                    Column(
                      children: [
                        Text("\n\n\n${"empty_basket".tr}\n", style: TextStyle(color: Colors.blue.shade200, fontStyle: FontStyle.italic)),
                        Lottie.asset('assets/lottie_basket.json', width: MediaQuery.of(context).size.width, height: 180, reverse: true, frameRate: FrameRate.composition),
                      ],
                    )
                  ],
                  CustomScrollView(
                    slivers: [
                      if (controller.basketState is MyErrorState) ...[
                        SliverToBoxAdapter(child: ErrorView(state: controller.basketState as MyErrorState)),
                      ],
                      if (controller.basketState.value != null && controller.basketState.value!.products.isNotEmpty) ...[
                        SliverToBoxAdapter(child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          child: Card(child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            child: Row(children: [
                              Expanded(child: Container(margin: const EdgeInsets.only(right: 16), child: Text("basket_text".tr, style: TextStyle(color: Colors.blue.shade700, height: 1.2)))),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(() => const CheckoutPage(), preventDuplicates: true);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade400,
                                  disabledBackgroundColor: Colors.blue.shade400,
                                  foregroundColor: Colors.white,
                                  disabledForegroundColor: Colors.white,
                                ),
                                child: Text("send_order".tr),
                              )
                            ]),
                          )),
                        )),
                        SliverList.separated(
                          itemCount: controller.basketState.value!.products.length,
                          itemBuilder: (context, i) {
                            return ProductRow(product: controller.basketState.value!.products[i]);
                          },
                          separatorBuilder: (context, i) {
                            return const SizedBox(height: 6);
                          },
                        )
                      ]
                    ],
                  ),
                ],
              )));
    });
  }
}
