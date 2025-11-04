import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/data/data_source/main_api.dart';

class OrderResponseView extends StatelessWidget {
  final OrderResponseDtoView order;

  const OrderResponseView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(child: Stack(children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [Container(margin: const EdgeInsets.only(right: 6, bottom: 0), child: const Icon(Icons.house, size: 18, color: Colors.blueGrey)), Text(order.pharmacyName, style: const TextStyle(fontWeight: FontWeight.bold))]),
                    Row(children: [Container(margin: const EdgeInsets.only(right: 6, bottom: 0), child: const Icon(Icons.phone, size: 18, color: Colors.blueGrey)), Text(order.pharmacyPhone)]),
                    Row(children: [Container(margin: const EdgeInsets.only(right: 6, bottom: 0), child: const Icon(Icons.location_on, size: 18, color: Colors.blueGrey)), Text(order.pharmacyAddress)]),
                    if (order.description.isNotEmpty) ...[
                      Row(children: [Container(margin: const EdgeInsets.only(right: 6, bottom: 0), child: const Icon(Icons.edit, size: 18, color: Colors.blueGrey)), Text(order.description)]),
                    ],
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 8),
                      child: DataTable(
                          border: TableBorder.all(color: Colors.grey.shade300, width: 1),
                          dividerThickness: 0.1,
                          horizontalMargin: 8,
                          columnSpacing: 16,
                          dataRowMinHeight: 32,
                          dataRowMaxHeight: 32,
                          headingRowHeight: 32,
                          columns: <DataColumn>[
                            DataColumn(label: Text('price'.tr, style: const TextStyle(color: Colors.black38))),
                            DataColumn(label: Text('product'.tr, style: const TextStyle(color: Colors.black38))),
                            DataColumn(label: Text('amount'.tr, style: const TextStyle(color: Colors.black38))),
                          ],
                          rows: order.lines.map((line) {
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(Text(line.price.toString())),
                                DataCell(Text(line.name)),
                                DataCell(Text(line.quantity.toString())),
                              ],
                            );
                          }).toList()),
                    ),
                  ],
                ),
              ),
            Row(children: [Expanded(child: Text(order.createdDate, style: const TextStyle(color: Colors.blueGrey, fontSize: 12))), Text(order.total.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), const Text("  TMT")]),
          ],
        ),
      ),
      Align(alignment: Alignment.topRight, child: IconButton(onPressed: () {

      }, icon: Icon(Icons.check, color: Colors.blue.shade400)))
    ]));
  }
}
