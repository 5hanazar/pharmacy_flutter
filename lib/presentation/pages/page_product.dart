import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/data/data_source/main_api.dart';
import 'package:pharmacy/data/repository.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Page')),
      body: FutureBuilder<ProductAndSimilarDto>(
        future: _repo.getProductById(widget.id),
        builder: (BuildContext context, AsyncSnapshot<ProductAndSimilarDto> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return Text(snapshot.data!.product.name);
          } else {
            return const Text('No data');
          }
        },
      ),
    );
  }
}
