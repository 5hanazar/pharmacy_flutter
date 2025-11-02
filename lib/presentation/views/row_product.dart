import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/data/data_source/main_api.dart';
import 'package:pharmacy/presentation/pages/page_product.dart';
import 'package:pharmacy/resources/controller_basket.dart';

class ProductRow extends StatefulWidget {
  final ProductDto product;

  const ProductRow({super.key, required this.product});

  @override
  State<ProductRow> createState() => _ProductRowState();
}

class _ProductRowState extends State<ProductRow> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 140,
        child: Card(
          child: Row(children: [
            GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CachedNetworkImage(
                      imageUrl: '$base/images/${widget.product.images[0]}',
                      placeholder: (context, url) => Image.asset('assets/no_image.webp'),
                      fadeInDuration: const Duration(milliseconds: 200),
                      fadeOutDuration: const Duration(milliseconds: 200),
                      errorWidget: (context, url, error) => Image.asset('assets/no_image.webp'),
                      cacheKey: widget.product.images[0],
                      width: 124, height: 124),
                ),
                onTap: () {
                  Get.to(() => ProductPage(id: widget.product.id), preventDuplicates: false, transition: Transition.upToDown, duration: const Duration(milliseconds: 400));
                }),
            Expanded(child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(widget.product.name, maxLines: 4, overflow: TextOverflow.ellipsis, style: const TextStyle(height: 1.2)),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Row(children: [
                      Text("~${widget.product.price} ", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                      const Text("TMT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue)),
                      const Spacer(),
                      Text("~${widget.product.price * widget.product.inBasket} ", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Text("TMT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ]),
                  )
                ],
              ),
            )),
            GetBuilder<BasketController>(builder: (controller) {
              final v = controller.basketState.value?.products.firstWhereOrNull((element) => element.id == widget.product.id)?.inBasket ?? 0;
              return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 24),
                          padding: EdgeInsets.zero,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(0),
                                bottomLeft: Radius.circular(16)),
                          )),
                      onPressed: () {
                        controller.postBasket(PostAdditionDto(productId: widget.product.id, addition: 1));
                      },
                      child: const Text("+")),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      v.toString(),
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  width: 44,
                  height: 44,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 24),
                          padding: EdgeInsets.zero,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(0),
                                bottomRight: Radius.circular(16),
                                bottomLeft: Radius.circular(0)),
                          )),
                      onPressed: () {
                        controller.postBasket(PostAdditionDto(productId: widget.product.id, addition: -1));
                      },
                      child: const Text("−")),
                )
              ]);
            })
          ]),
        ));
  }
}
