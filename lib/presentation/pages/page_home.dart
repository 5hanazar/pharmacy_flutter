import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/data/data_source/main_api.dart';
import 'package:pharmacy/domain/data_state.dart';
import 'package:pharmacy/presentation/pages/page_pharmacies.dart';
import 'package:pharmacy/presentation/pages/page_products.dart';
import 'package:pharmacy/presentation/views/card_product.dart';
import 'package:pharmacy/presentation/views/dialog_language.dart';
import 'package:pharmacy/presentation/views/view_error.dart';
import 'package:pharmacy/presentation/views/view_pharmacy.dart';
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
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return LanguageDialog(
          onConfirm: (value) async {
            await Get.updateLocale(value);
            await controller.setLanguage(value.languageCode == "ru" ? 1 : 2);
            controller.refreshHome();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Şypa", style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold)),
            titleSpacing: 8,
            leading: Padding(padding: const EdgeInsets.only(left: 10, top: 6, right: 0, bottom: 6), child: Image.asset('assets/ic_launcher.png')),
            actions: [
              IconButton(
                onPressed: () {
                  _showLanguageDialog(context);
                },
                icon: const Icon(Icons.translate),
              ),
              IconButton(
                onPressed: () {
                  Get.to(() => const ProductsPage(groupCode: ""), preventDuplicates: false);
                },
                icon: const Icon(Icons.search),
              )
            ]),
        body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () => controller.refreshHome(),
            backgroundColor: Colors.white,
            child: GetBuilder<HomeController>(builder: (controller) {
              return CustomScrollView(
                slivers: [
                  if (controller.homeState is MyErrorState) ...[
                    SliverToBoxAdapter(child: ErrorView(state: controller.homeState as MyErrorState)),
                  ],
                  if (controller.homeState.value != null) ...[
                    const SliverToBoxAdapter(child: _Caution()),
                    SliverToBoxAdapter(child: _CategoriesHorizontal(list: controller.homeState.value!.categories, onClick: (code) {
                      Get.to(() => ProductsPage(groupCode: code), preventDuplicates: false);
                    })),

                    if (controller.homeState.value!.pharmacies.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: _Title(
                          title: "all_pharmacies".tr,
                          onMoreClick: () {
                            Get.to(() => const PharmaciesPage(), preventDuplicates: true);
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _PharmaciesHorizontal(
                          list: controller.homeState.value!.pharmacies,
                          onClick: (_) {},
                        ),
                      )
                    ],

                    ...controller.homeState.value!.list.expand((e) => [
                      SliverToBoxAdapter(
                        child: _Title(
                          title: e.title,
                          onMoreClick: () { Get.to(() => ProductsPage(groupCode: e.code), preventDuplicates: true); },
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

class _Caution extends StatelessWidget {
  const _Caution();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          border: Border.all(
            color: Colors.blue,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text("text1".tr, style: const TextStyle(color: Colors.blue)),
        ));
  }
}

class _CategoriesHorizontal extends StatelessWidget {
  final List<CategoryDto> list;
  final Function(String code) onClick;

  const _CategoriesHorizontal({required this.list, required this.onClick});

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
                    borderRadius: BorderRadius.circular(26),
                    side: const BorderSide(
                      color: Colors.blue, // Border color
                      width: 0.5, // Border width
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(child: Text(list[index].name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
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
    final double textScaleFactor = MediaQuery.of(context).textScaler.scale(1);
    return list.isEmpty
        ? Container(
            height: 100,
            alignment: Alignment.center,
            child: const Text("Нет данных"),
          )
        : SizedBox(
            height: (MediaQuery.of(context).size.width / 2) + (160 * textScaleFactor),
            child: PageView.builder(
                padEnds: false,
                controller: PageController(viewportFraction: 0.5),
                itemBuilder: (context, index) => ProductCard(product: list[index]),
                itemCount: list.length),
          );
  }
}

class _PharmaciesHorizontal extends StatelessWidget {
  final List<PharmacyDtoView> list;
  final Function(String code) onClick;

  const _PharmaciesHorizontal({required this.list, required this.onClick});

  @override
  Widget build(BuildContext context) {
    final double textScaleFactor = MediaQuery.of(context).textScaler.scale(1);
    return SizedBox(
      height: 100 * textScaleFactor,
      child: PageView.builder(
          padEnds: false,
          controller: PageController(viewportFraction: 0.7),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                onClick(list[index].name);
              },
              child: PharmacyView(pharmacy: list[index]),
            );
          },
          itemCount: list.length),
    );
  }
}
