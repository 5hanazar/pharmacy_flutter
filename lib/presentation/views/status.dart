import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Status extends StatelessWidget {
  final String msg;
  final Function() onRefresh;

  const Status({super.key, required this.msg, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              msg,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: const TextStyle(fontSize: 16),
            ),
            ElevatedButton(onPressed: onRefresh, style: TextButton.styleFrom(foregroundColor: Colors.white), child: Text("refresh".tr))
          ],
        ),
      ),
    );
  }
}
