import 'package:flutter/material.dart';
import 'package:sos_connect/main.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: appTheme.appColor));
  }
}
