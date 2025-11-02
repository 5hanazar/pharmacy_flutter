import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:pharmacy/data/data_source/main_api.dart';
import 'package:pharmacy/presentation/pages/page_product.dart';
import 'package:pharmacy/resources/controller_basket.dart';

class ProductCard extends StatefulWidget {
  final ProductDto product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final pluses = <Widget>[];

  void _onPressed(bool isPlus) {
    final id = UniqueKey();
    final plus = Text(
      isPlus ? "+1" : "-1",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isPlus ? Colors.green : Colors.red),
    )
        .animate(key: id, onComplete: (c) {
          _remove(id);
        })
        .fadeIn(duration: 50.ms)
        .moveY(begin: 0, end: -50, duration: 400.ms, curve: Curves.easeOut)
        .then()
        .fadeOut(duration: 200.ms);
    setState(() => pluses.add(plus));
  }

  void _remove(Key id) => setState(() => pluses.removeWhere((p) => p.key == id));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: (MediaQuery.of(context).size.width / 2) + 160,
        child: Card(
          child: Column(children: [
            GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CachedNetworkImage(
                      imageUrl: '$base/images/${widget.product.images[0]}',
                      placeholder: (context, url) => Image.asset('assets/no_image.webp'),
                      fadeInDuration: const Duration(milliseconds: 200),
                      fadeOutDuration: const Duration(milliseconds: 200),
                      errorWidget: (context, url, error) => Image.asset('assets/no_image.webp'),
                      cacheKey: widget.product.images[0],
                      width: double.infinity,
                      height: (MediaQuery.of(context).size.width / 2) - 24),
                ),
                onTap: () {
                  Get.to(() => ProductPage(id: widget.product.id), preventDuplicates: false, transition: Transition.upToDown, duration: const Duration(milliseconds: 400));
                }),
            Expanded(child: Padding(padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 0), child: Text(widget.product.name, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(height: 1.2)))),
            Padding(
                padding: const EdgeInsets.all(8),
                child: Row(children: [
                  Text(widget.product.groupName.length > 8 ? '${widget.product.groupName.substring(0, 8)}...' : widget.product.groupName, style: const TextStyle(color: Colors.grey)),
                  const Spacer(),
                  Text("~${widget.product.price} ", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                  const Text("TMT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue)),
                ])),
            Stack(
              alignment: Alignment.center,
              children: [
                GetBuilder<BasketController>(builder: (controller) {
                  final v = controller.basketState.value?.products.firstWhereOrNull((element) => element.id == widget.product.id)?.inBasket ?? 0;
                  return v > 0
                      ? Row(
                    children: [
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
                            onPressed: () async {
                              await controller.postBasket(PostAdditionDto(productId: widget.product.id, addition: -1));
                              _onPressed(false);
                            },
                            child: const Text("−")),
                      ),
                      Expanded(child: Text(v.toString(), style: const TextStyle(fontSize: 18), textAlign: TextAlign.center)),
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
                            onPressed: () async {
                              await controller.postBasket(PostAdditionDto(productId: widget.product.id, addition: 1));
                              _onPressed(true);
                            },
                            child: const Text("+")),
                      )
                    ],
                  )
                      : SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(0),
                                bottom: Radius.circular(16),
                              ),
                            )),
                        onPressed: () async {
                          await controller.postBasket(PostAdditionDto(productId: widget.product.id, addition: 1));
                          _onPressed(true);
                        },
                        child: Text("add_to_basket".tr)),
                  );
                }),
                ...pluses,
              ],
            )
          ]),
        ));
  }
}
