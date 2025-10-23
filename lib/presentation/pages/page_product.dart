import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pharmacy/data/data_source/main_api.dart';
import 'package:pharmacy/data/repository.dart';
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
            return CustomScrollView(scrollBehavior: const ScrollBehavior().copyWith(overscroll: false), slivers: [
              if (snapshot.hasData) ...[
                SliverAppBar(
                  title: Text(snapshot.data!.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white,
                  systemOverlayStyle: const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
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
                        CachedNetworkImage(
                            imageUrl: '$base/images/${snapshot.data!.product.images[0]}',
                            errorWidget: (context, url, error) => Align(alignment: Alignment.center, child: Icon(Icons.no_photography, color: Colors.black.withOpacity(0.2), size: 100)),
                            fit: BoxFit.cover,

                            height: MediaQuery.sizeOf(context).width),
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
                SliverList(delegate: SliverChildListDelegate([
                  ListTile(title: Text(snapshot.data!.product.name, style: const TextStyle(height: 1.2, fontWeight: FontWeight.bold)), subtitle: const Text("Названия"), leading: const Icon(Icons.text_fields)),
                  ListTile(title: Text(snapshot.data!.product.groupName, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: const Text("Группа"), leading: const Icon(Icons.account_tree_outlined)),
                  ListTile(title: Text(snapshot.data!.product.price.toString()), subtitle: const Text("Цена (TMT)"), leading: const Icon(Icons.monetization_on_outlined)),
                  ListTile(title: Text(snapshot.data!.product.barcode), subtitle: const Text("Бар-код"), leading: const Icon(Icons.qr_code_2)),
                  if (snapshot.data!.product.description.isNotEmpty) ...[
                    ListTile(
                        title: Text(snapshot.data!.product.description),
                        leading: const Icon(Icons.description),
                        titleAlignment: ListTileTitleAlignment.titleHeight)
                  ]
                ]))
              ]
            ]);
          }),
    );
  }
}
