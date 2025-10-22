import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/domain/data_state.dart';

class ErrorView extends StatelessWidget {
  final MyErrorState state;

  String _errorFormat(String error) {
    if (error.contains("connection")) {
      return "error_connection".tr;
    } else {
      return "error_unknown".tr;
    }
  }

  const ErrorView({super.key, required this.state});
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.orange.shade200,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(_errorFormat(state.msg), textAlign: TextAlign.center),
        )
    );
  }
}
