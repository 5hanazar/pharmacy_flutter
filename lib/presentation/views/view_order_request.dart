import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/data/data_source/main_api.dart';
import 'package:pharmacy/resources/controller_order_requests.dart';

class OrderRequestView extends StatelessWidget {
  final OrderRequestsController _controller = Get.find();
  final OrderRequestDtoView order;

  OrderRequestView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(child: Stack(children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [Container(margin: const EdgeInsets.only(right: 6, bottom: 0), child: const Icon(Icons.phone, size: 18, color: Colors.blueGrey)), Text(order.phone, style: const TextStyle(fontWeight: FontWeight.bold))]),
            Row(children: [Container(margin: const EdgeInsets.only(right: 6, bottom: 0), child: const Icon(Icons.pin_drop, size: 18, color: Colors.blueGrey)), Text(order.address)]),
            if (order.description.isNotEmpty) ...[
              Row(children: [Container(margin: const EdgeInsets.only(right: 6, bottom: 0), child: const Icon(Icons.edit, size: 18, color: Colors.blueGrey)), Text(order.description)]),
            ],
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    border: TableBorder.all(color: Colors.grey.shade300, width: 1),
                    dividerThickness: 0.1,
                    horizontalMargin: 8,
                    columnSpacing: 16,
                    dataRowMinHeight: 30,
                    dataRowMaxHeight: 30,
                    headingRowHeight: 30,
                    columns: const <DataColumn>[
                      DataColumn(label: Text('Кол.')),
                      DataColumn(label: Text('Товар')),
                      DataColumn(label: Text('Цена')),
                    ],
                    rows: order.lines.map((line) {
                      return DataRow(
                        cells: <DataCell>[
                          DataCell(Text(line.quantity.toString())),
                          DataCell(Text(line.name)),
                          DataCell(Text(line.price.toString())),
                        ],
                      );
                    }).toList()),
              ),
            ),
            Row(children: [Expanded(child: Text(order.createdDate, style: const TextStyle(color: Colors.blueGrey, fontSize: 12))), Text(order.total.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), const Text("  TMT")]),
          ],
        ),
      ),
      Align(alignment: Alignment.topRight, child: IconButton(onPressed: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('cancel_order'.tr),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
                child: Text('no'.tr),
              ),
              TextButton(onPressed: () async {
                await _controller.deleteOrderRequest(order.id);
                if (context.mounted) Navigator.pop(context);
              }, child: Text('yes'.tr)),
            ],
          ),
        );
      }, icon: Icon(Icons.close, color: Colors.grey.shade400)))
    ]));
  }
}
