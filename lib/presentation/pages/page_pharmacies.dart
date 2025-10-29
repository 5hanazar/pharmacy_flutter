import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pharmacy/data/data_source/main_api.dart';
import 'package:pharmacy/data/repository.dart';
import 'package:pharmacy/presentation/views/status.dart';
import 'package:pharmacy/presentation/views/view_pharmacy.dart';

class PharmaciesPage extends StatefulWidget {
  const PharmaciesPage({super.key});

  @override
  State<PharmaciesPage> createState() => _PharmaciesPageState();
}

class _PharmaciesPageState extends State<PharmaciesPage> {
  final RepositoryImpl _repo = Get.find();

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  String _searchTerm = "";
  final String _sortBy = "";
  final PagingController<int, PharmacyDtoView> _pagingController =
      PagingController(firstPageKey: 0);

  Future<void> _fetchPage(int pageKey) async {
    try {
      final result = await _repo.getPharmacies(pageKey + 1, _sortBy, _searchTerm);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            titleSpacing: 8,
            title: Text("all_pharmacies".tr, style: const TextStyle(fontWeight: FontWeight.bold)),
            bottom: AppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 4,
              title: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
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
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(22)),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(22)),
                        borderSide: BorderSide(width: 0.5, color: Colors.blue),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(22)),
                        borderSide: BorderSide(width: 1.5, color: Colors.blue),
                      ),
                      filled: true,
                      fillColor: Colors.white),
                ),
              ),
            ),
          ),
          PagedSliverList<int, PharmacyDtoView>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<PharmacyDtoView>(
              noItemsFoundIndicatorBuilder: (_) => Center(child: Text("not_found".tr, style: const TextStyle(fontSize: 16))),
              firstPageErrorIndicatorBuilder: (_) => Status(msg: _pagingController.error.toString(), onRefresh: () => _pagingController.refresh()),
              newPageErrorIndicatorBuilder: (_) => Status(msg: _pagingController.error.toString(), onRefresh: () => _pagingController.retryLastFailedRequest()),
              newPageProgressIndicatorBuilder: (_) => Container(alignment: Alignment.center, height: 100, child: const CircularProgressIndicator()),
              itemBuilder: (context, item, index) => PharmacyView(pharmacy: item),
            ),
          )
        ],
      ),
    );
  }
}
