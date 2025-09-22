import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/data/data_source/main_api.dart';

class ProductCard extends StatelessWidget {
  final ProductDto product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: (MediaQuery.of(context).size.width / 2) + 160,
        child: Card(
          child: Column(children: [
            GestureDetector(
                child: CachedNetworkImage(
                    imageUrl: '$base/images/${product.images[0]}',
                    placeholder: (context, url) => Image.asset('assets/no_image.webp'),
                    fadeInDuration: const Duration(milliseconds: 200),
                    fadeOutDuration: const Duration(milliseconds: 200),
                    errorWidget: (context, url, error) => Image.asset('assets/no_image.webp'),
                    cacheKey: product.images[0],
                    width: double.infinity,
                    height: (MediaQuery.of(context).size.width / 2)),
                onTap: () {}),
            Expanded(child: Padding(padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 0), child: Text(product.name, maxLines: 3, style: const TextStyle(height: 1.2)))),
            Padding(
                padding: const EdgeInsets.all(8),
                child: Row(children: [
                  Text(product.groupName.length > 8 ? '${product.groupName.substring(0, 8)}...' : product.groupName, style: const TextStyle(color: Colors.grey)),
                  const Spacer(),
                  Text("~${product.price} ", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                  const Text("TMT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue)),
                ])),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                  child: Text("add_to_basket".tr),
                  onPressed: () {

                  }),
            )
          ]),
        ));
  }
}
