import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    refreshList();
  }

  Future<void> refreshList() async {
    await controller.refreshOrderRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("orders".tr, style: const TextStyle(fontWeight: FontWeight.bold))),
      body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: refreshList,
          backgroundColor: Colors.white,
          child: GetBuilder<OrderRequestsController>(builder: (controller) {
            return CustomScrollView(
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
            );
          }))
    );
  }
}
