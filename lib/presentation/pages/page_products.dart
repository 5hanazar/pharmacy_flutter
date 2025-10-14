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
  int _sortBy = 0;
  final PagingController<int, ProductDto> _pagingController = PagingController(firstPageKey: 0);

  Future<void> _fetchPage(int pageKey) async {
    try {
      final result = await repo.getProducts(pageKey + 1, widget.groupCode, _searchTerm);
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

  void changeSort(int value) {
    Get.back();
    if (_sortBy == value) return;
    _sortBy = value;
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            title: Text(_title, style: const TextStyle(fontWeight: FontWeight.bold)),
            bottom: AppBar(
              automaticallyImplyLeading: false,
              title: TextField(
                onSubmitted: (query) {
                  _searchTerm = query;
                  _pagingController.refresh();
                },
                autofocus: false,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
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
