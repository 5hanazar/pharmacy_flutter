import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pharmacy/data/data_source/main_api.dart';
import 'package:pharmacy/data/repository.dart';
import 'package:pharmacy/presentation/views/card_product.dart';
import 'package:pharmacy/presentation/views/status.dart';

class ProductsPage extends StatefulWidget {
  final String groupCode;

  const ProductsPage({super.key, required this.groupCode});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final RepositoryImpl repo = Get.find();

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  String _title = "";
  String _searchTerm = "";
  String _sortBy = "";
  String _sortLabel = "";
  final PagingController<int, ProductDto> _pagingController = PagingController(firstPageKey: 0);

  Future<void> _fetchPage(int pageKey) async {
    if (widget.groupCode == "" && _searchTerm.isEmpty) {
      _pagingController.appendLastPage([]);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _title = "all_products".tr;
          });
        }
      });
      return;
    }
    try {
      final result = await repo.getProducts(pageKey + 1, widget.groupCode, _sortBy, _searchTerm);
      setState(() {
        _title = result.groupName;
      });
      final newItems = result.data;
      final isLastPage = newItems.isEmpty;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } on Exception catch (error, _) {
      _pagingController.error = error;
    }
  }

  void _changeSort(String value) {
    if (_sortBy == value) return;
    _sortBy = value;
    _pagingController.refresh();
  }

  void _showListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Сортировка'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () { Navigator.pop(context, ['', '']); },
              child: Text('sort1'.tr),
            ),
            SimpleDialogOption(
              onPressed: () { Navigator.pop(context, ['namesJ;ascending', "${'sort2'.tr} ↑"]); },
              child: Text("${'sort2'.tr} ↑ (A-Z)"),
            ),
            SimpleDialogOption(
              onPressed: () { Navigator.pop(context, ['namesJ;descending', "${'sort2'.tr} ↓"]); },
              child: Text("${'sort2'.tr} ↓ (Z-A)"),
            ),
            SimpleDialogOption(
              onPressed: () { Navigator.pop(context, ['price;ascending', "${'sort3'.tr} ↑"]); },
              child: Text("${'sort3'.tr} ↑ (${'sort_price1'.tr})"),
            ),
            SimpleDialogOption(
              onPressed: () { Navigator.pop(context, ['price;descending', "${'sort3'.tr} ↓"]); },
              child: Text("${'sort3'.tr} ↓ (${'sort_price2'.tr})"),
            ),
          ],
        );
      },
    ).then((selectedOption) {
      if (selectedOption != null) {
        _sortLabel = selectedOption[1];
        _changeSort(selectedOption[0]);
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You selected: $selectedOption')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            titleSpacing: 8,
            title: Text(_title, style: const TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              Container(margin: const EdgeInsets.symmetric(horizontal: 16), child: Text(_sortLabel))
            ],
            bottom: AppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 4,
              actions: [
                Container(margin: const EdgeInsets.only(right: 8), child: IconButton(onPressed: () {
                  _showListDialog(context);
                }, icon: const Icon(Icons.sort)))
              ],
              title: Container(
                margin: const EdgeInsets.only(left: 10),
                child: TextField(
                  onSubmitted: (query) {
                    _searchTerm = query;
                    _pagingController.refresh();
                  },
                  autofocus: false,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      suffixIcon: const Icon(Icons.search),
                      hintText: "search".tr,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(width: 2, color: Colors.grey.shade400),
                      ),
                      filled: true,
                      fillColor: Colors.white),
                ),
              ),
            ),
          ),
          PagedSliverGrid<int, ProductDto>(
            showNewPageProgressIndicatorAsGridChild: false,
            showNewPageErrorIndicatorAsGridChild: false,
            showNoMoreItemsIndicatorAsGridChild: false,
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<ProductDto>(
              noItemsFoundIndicatorBuilder: (_) => Center(child: Text(_searchTerm == "" ? "Type to search" : "not_found".tr, style: const TextStyle(fontSize: 16))),
              firstPageErrorIndicatorBuilder: (_) => Status(msg: _pagingController.error.toString(), onRefresh: () => _pagingController.refresh()),
              newPageErrorIndicatorBuilder: (_) => Status(msg: _pagingController.error.toString(), onRefresh: () => _pagingController.retryLastFailedRequest()),
              newPageProgressIndicatorBuilder: (_) => Container(alignment: Alignment.center, height: 100, child: const CircularProgressIndicator()),
              itemBuilder: (context, item, index) => ProductCard(product: item),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent:
              (MediaQuery.of(context).size.width / 2) + 160,
            ),
          ),
        ],
      ),
    );
  }
}
