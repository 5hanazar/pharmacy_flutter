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

  Future<void> refreshList() async {
    //await controller.refreshProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ProductAndSimilarDto>(
          future: _repo.getProductById(widget.id),
          builder: (BuildContext context, AsyncSnapshot<ProductAndSimilarDto> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return CustomScrollView(
                scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
                slivers: [
                  if (snapshot.hasData) ...[
                    SliverAppBar(
                      title: Text(snapshot.data!.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      //systemOverlayStyle: const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
                      pinned: true,
                      actions: [
                        IconButton(
                            icon: const Icon(Icons.share),
                            tooltip: 'Поделиться',
                            onPressed: () async {}),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.none,
                        background: Stack(
                          children: [
                            Container(
                              color: Colors.white,
                              child: CachedNetworkImage(
                                  imageUrl: '$base/images/${snapshot.data!.product.images[0]}',
                                  errorWidget: (context, url, error) => Align(
                                      alignment: Alignment.center,
                                      child: Icon(Icons.no_photography,
                                          color: Colors.black.withOpacity(0.2),
                                          size: 100)),
                                  fit: BoxFit.cover,
                                  height: MediaQuery.sizeOf(context).width),
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
                    SliverToBoxAdapter(child: Card(
                      child: Table(columnWidths: const <int, TableColumnWidth>{
                        0: FixedColumnWidth(90),
                        1: FlexColumnWidth()
                      }, children: <TableRow>[
                        TableRow(children: [
                          Text("${"name".tr}:",
                              textAlign: TextAlign.end,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(snapshot.data!.product.name)
                        ]),
                        TableRow(children: [
                          Text("${"group".tr}:",
                              textAlign: TextAlign.end,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(snapshot.data!.product.groupName)
                        ]),
                        TableRow(children: [
                          Text("${"barcode".tr}:",
                              textAlign: TextAlign.end,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(snapshot.data!.product.barcode)
                        ]),
                        TableRow(children: [
                          Text("${"price".tr}:",
                              textAlign: TextAlign.end,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(snapshot.data!.product.price.toString())
                        ])
                      ]),
                    )),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16, right: 16, bottom: 12, left: 16),
                        child: Text("similar".tr,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent:
                            (MediaQuery.of(context).size.width / 2) + 160,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return ProductCard(
                              product: snapshot.data!.similar[index]);
                        },
                        childCount: snapshot.data!.similar.length,
                      ),
                    )
                  ]
                ]);
          }),
    );
  }
}
