import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmacy/domain/data_state.dart';
import 'package:pharmacy/presentation/views/view_error.dart';
import 'package:pharmacy/presentation/views/view_order_request.dart';
import 'package:pharmacy/resources/controller_order_requests.dart';

class OrderRequestsPage extends StatefulWidget {
  const OrderRequestsPage({super.key});

  @override
  State<OrderRequestsPage> createState() => _OrderRequestsPageState();
}

class _OrderRequestsPageState extends State<OrderRequestsPage> {
  final OrderRequestsController controller = Get.find();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("orders".tr, style: const TextStyle(fontWeight: FontWeight.bold))),
      body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () => controller.refreshOrderRequests(),
          backgroundColor: Colors.white,
          child: GetBuilder<OrderRequestsController>(builder: (controller) {
            return Stack(
              children: [
                if (controller.orderRequestsState.value != null && controller.orderRequestsState.value!.data.isEmpty) ...[
                  Column(
                    children: [
                      Text("\n\n\n${"no_orders".tr}\n", style: TextStyle(color: Colors.blue.shade200, fontStyle: FontStyle.italic)),
                      Lottie.asset('assets/empty_orders.json', width: MediaQuery.of(context).size.width, height: 180, repeat: false, frameRate: FrameRate.composition),
                    ],
                  )
                ],
                CustomScrollView(
                  slivers: [
                    if (controller.orderRequestsState is MyErrorState) ...[
                      SliverToBoxAdapter(child: ErrorView(state: controller.orderRequestsState as MyErrorState)),
                    ],
                    if (controller.orderRequestsState.value != null) ...[
                      SliverList.separated(
                        itemCount: controller.orderRequestsState.value!.count,
                        itemBuilder: (context, i) {
                          return OrderRequestView(order: controller.orderRequestsState.value!.data[i]);
                        },
                        separatorBuilder: (context, i) {
                          return const SizedBox(height: 0);
                        },
                      )
                    ],
                  ],
                ),
              ],
            );
          }))
    );
  }
}
