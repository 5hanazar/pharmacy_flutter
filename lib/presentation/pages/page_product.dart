import 'package:barcode_widgets/barcode_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pharmacy/data/data_source/main_api.dart';
import 'package:pharmacy/data/repository.dart';
import 'package:pharmacy/presentation/views/card_product.dart';
import 'package:pharmacy/resources/controller_basket.dart';

class ProductPage extends StatefulWidget {
  final int id;

  const ProductPage({super.key, required this.id});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final RepositoryImpl _repo = Get.find();

  @override
  void initState() {
    super.initState();
  }

  Future<ProductAndSimilarDto?> refreshPage() async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      return await _repo.getProductById(widget.id);
    } on Exception catch (error, _) {
      Get.back();
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ProductAndSimilarDto?>(
          future: refreshPage(),
          builder: (BuildContext context, AsyncSnapshot<ProductAndSimilarDto?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.dark,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.data == null) return const SizedBox();
            return CustomScrollView(scrollBehavior: const ScrollBehavior().copyWith(overscroll: false), slivers: [
              SliverAppBar(
                title: Text(snapshot.data!.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                pinned: true,
                actions: [
                  IconButton(icon: const Icon(Icons.share), tooltip: 'Поделиться', onPressed: () async {}),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.none,
                  background: Stack(
                    children: [
                      ColoredBox(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 32, right: 24, bottom: 16, left: 24),
                          child: CachedNetworkImage(
                              imageUrl: '$base/images/${snapshot.data!.product.images[0]}',
                              errorWidget: (context, url, error) => Align(alignment: Alignment.center, child: Icon(Icons.no_photography, color: Colors.black.withOpacity(0.2), size: 100)),
                              cacheKey: snapshot.data!.product.images[0],
                              fit: BoxFit.cover,
                              height: (MediaQuery.sizeOf(context).width) - 48),
                        ),
                      ),
                      Container(
                        height: 56 + MediaQuery.of(context).viewPadding.top,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black, Colors.transparent],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                expandedHeight: MediaQuery.sizeOf(context).width - MediaQuery.of(context).viewPadding.top,
              ),
              SliverToBoxAdapter(child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.blue, width: 0.5),
                    bottom: BorderSide(color: Colors.blue, width: 0.5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(snapshot.data!.product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.2)),
                      Container(margin: const EdgeInsets.only(top: 6), child: Text(snapshot.data!.product.groupName, style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic))),
                      Container(
                        margin: const EdgeInsets.only(top: 16, bottom: 28),
                        child: Row(children: [
                          Text("~${snapshot.data!.product.price} ", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue)),
                          const Text("TMT", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
                          const Spacer(),
                          BarCodeImage(
                            params: Code128BarCodeParams(
                              snapshot.data!.product.barcode,
                              lineWidth: 1,
                              barHeight: 50,
                              withText: true,
                            ),
                          )
                        ]),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 180,
                          child: GetBuilder<BasketController>(builder: (controller) {
                            final v = controller.basketState.value?.products.firstWhereOrNull((element) => element.id == widget.id)?.inBasket ?? 0;
                            return v > 0
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: 44,
                                        height: 44,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 24), padding: EdgeInsets.zero),
                                            onPressed: () {
                                              controller.postBasket(PostAdditionDto(productId: widget.id, addition: -1));
                                            },
                                            child: const Text("−")),
                                      ),
                                      Expanded(child: Text(v.toString(), style: const TextStyle(fontSize: 18), textAlign: TextAlign.center)),
                                      SizedBox(
                                        width: 44,
                                        height: 44,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 24), padding: EdgeInsets.zero),
                                            onPressed: () {
                                              controller.postBasket(PostAdditionDto(productId: widget.id, addition: 1));
                                            },
                                            child: const Text("+")),
                                      )
                                    ],
                                  )
                                : SizedBox(
                                    width: double.infinity,
                                    height: 44,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          controller.postBasket(PostAdditionDto(productId: widget.id, addition: 1));
                                        },
                                        child: Text("add_to_basket".tr)),
                                  );
                          }),
                        ),
                      )
                    ],
                  ),
                ),
              )),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24, right: 16, bottom: 12, left: 16),
                  child: Text("similar".tr, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: (MediaQuery.of(context).size.width / 2) + 160,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return ProductCard(product: snapshot.data!.similar[index]);
                  },
                  childCount: snapshot.data!.similar.length,
                ),
              )
            ]);
          }),
    );
  }
}
