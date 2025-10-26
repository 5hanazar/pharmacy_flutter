import 'package:flutter/material.dart';
import 'package:pharmacy/domain/data_state.dart';
import 'package:pharmacy/main.dart';

class ErrorView extends StatelessWidget {
  final MyErrorState state;

  const ErrorView({super.key, required this.state});
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.orange.shade200,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(errorFormat(state.msg), textAlign: TextAlign.center),
        )
    );
  }
}
