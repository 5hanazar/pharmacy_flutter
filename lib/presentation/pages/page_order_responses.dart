import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/data/data_source/main_api.dart';
import 'package:pharmacy/presentation/views/view_order_response.dart';

class OrderResponsesPage extends StatefulWidget {
  final OrderRequestDtoView orderRequest;
  const OrderResponsesPage({super.key, required this.orderRequest});

  @override
  State<OrderResponsesPage> createState() => _OrderResponsesPageState();
}

class _OrderResponsesPageState extends State<OrderResponsesPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("responses".tr, style: const TextStyle(fontWeight: FontWeight.bold))),
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverList.separated(
                  itemCount: widget.orderRequest.responses.length,
                  itemBuilder: (context, i) {
                    return OrderResponseView(order: widget.orderRequest.responses[i]);
                  },
                  separatorBuilder: (context, i) {
                    return const SizedBox(height: 0);
                  },
                )
              ],
            ),
          ],
        )
    );
  }
}
