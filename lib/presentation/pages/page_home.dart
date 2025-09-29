import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/data/data_source/main_api.dart';
import 'package:pharmacy/domain/data_state.dart';
import 'package:pharmacy/presentation/pages/page_products.dart';
import 'package:pharmacy/presentation/views/card_product.dart';
import 'package:pharmacy/presentation/views/error_view.dart';
import 'package:pharmacy/resources/controller_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = Get.find();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  Future<void> refreshList() async {
    await controller.refreshHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Şypa", style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold)), actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const ProductsPage(groupCode: ""), preventDuplicates: false);
            },
            icon: const Icon(Icons.search),
          )
        ]),
        body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: refreshList,
            backgroundColor: Colors.white,
            child: GetBuilder<HomeController>(builder: (controller) {
              return CustomScrollView(
                slivers: [
                  if (controller.homeState is MyErrorState) ...[
                    SliverToBoxAdapter(child: ErrorView(state: controller.homeState as MyErrorState)),
                  ],
                  if (controller.homeState.value != null) ...[
                    SliverToBoxAdapter(child: _CategoriesHorizontal(list: controller.homeState.value!.categories, code: "", onClick: (code) {
                      Get.to(() => ProductsPage(groupCode: code), preventDuplicates: false);
                    })),
                    ...controller.homeState.value!.list.expand((e) => [
                      SliverToBoxAdapter(
                        child: _Title(
                          title: e.title,
                          onMoreClick: () { Get.to(() => ProductsPage(groupCode: e.code), preventDuplicates: false); },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _ProductsHorizontal(
                          list: e.products,
                        ),
                      ),
                    ]),
                  ],
                ],
              );
            })));
  }
}

class _CategoriesHorizontal extends StatelessWidget {
  final List<CategoryDto> list;
  final String code;
  final Function(String code) onClick;

  const _CategoriesHorizontal({required this.list, required this.code, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: PageView.builder(
          padEnds: false,
          controller: PageController(viewportFraction: 0.4),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                onClick(list[index].code);
              },
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Align(child: Text(list[index].name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  )),
            );
          },
          itemCount: list.length),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;
  final Function() onMoreClick;

  const _Title({required this.title, required this.onMoreClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 16, top: 16, right: 12, bottom: 2),
        child: Row(
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            IconButton(
                style: IconButton.styleFrom(backgroundColor: Colors.grey.shade200),
                iconSize: 36,
                padding: const EdgeInsets.all(0),
                constraints: const BoxConstraints(),
                onPressed: () {
                  onMoreClick();
                },
                icon: Icon(Icons.arrow_right, color: Colors.grey.shade400))
          ],
        ));
  }
}

class _ProductsHorizontal extends StatelessWidget {
  final List<ProductDto> list;

  const _ProductsHorizontal({required this.list});

  @override
  Widget build(BuildContext context) {
    return list.isEmpty
        ? Container(
            height: 100,
            alignment: Alignment.center,
            child: const Text("Нет данных"),
          )
        : SizedBox(
            height: (MediaQuery.of(context).size.width / 2) + 160,
            child: PageView.builder(
                padEnds: false,
                controller: PageController(viewportFraction: 0.5),
                itemBuilder: (context, index) => ProductCard(product: list[index]),
                itemCount: list.length),
          );
  }
}
