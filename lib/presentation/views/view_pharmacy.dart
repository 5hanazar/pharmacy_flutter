import 'package:flutter/material.dart';
import 'package:pharmacy/data/data_source/main_api.dart';

class PharmacyView extends StatelessWidget {
  final PharmacyDtoView pharmacy;

  const PharmacyView({super.key, required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pharmacy.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
            Row(children: [
              Container(margin: const EdgeInsets.only(right: 6, bottom: 0), child: const Icon(Icons.phone, size: 18, color: Colors.blueGrey)),
              Expanded(child: Text(pharmacy.phones.join("; "), maxLines: 1, overflow: TextOverflow.ellipsis))
            ]),
            Row(children: [
              Container(margin: const EdgeInsets.only(right: 6, bottom: 0), child: const Icon(Icons.pin_drop, size: 18, color: Colors.blueGrey)),
              Expanded(child: Text(pharmacy.address, maxLines: 1, overflow: TextOverflow.ellipsis))
            ]),
          ],
        ),
      ),
    );
  }
}
